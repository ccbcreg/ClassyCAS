require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'
require 'addressable/uri'
require 'nokogiri'

require 'lib/login_ticket'
require 'lib/proxy_ticket'
require 'lib/service_ticket'
require 'lib/ticket_granting_ticket'

before do
  @redis = Redis.new
end

get "/hello_world" do
  "hello world"
end

get "/login" do
  @service_url = Addressable::URI.parse(params[:service])
  @renew = [true, "true", "1", 1].include?(params[:renew])
  @gateway = [true, "true", "1", 1].include?(params[:gateway])
  
  if @renew
    haml :login
  elsif @gateway
    if @service_url
      if sso_session
        st = ServiceTicket.new(@service_url, sso_session.username)
        redirect_url = @service_url.clone
        redirect_url.query_values = @service_url.query_values.merge(:ticket => st.ticket)
      
        redirect redirect_url.to_s, 303
      else
        redirect @service_url.to_s, 303
      end
    else
      haml :login
    end
  else
    if sso_session
      if @service_url
        st = ServiceTicket.new(@service_url, sso_session.username)
        redirect_url = @service_url.clone
        redirect_url.query_values = @service_url.query_values.merge(:ticket => st.ticket)
      
        redirect redirect_url.to_s, 303
      else
        return haml :already_logged_in
      end
    else
      haml :login
    end
  end
end

post "/login" do
  username = params[:username]
  password = params[:password]
  
  service_url = params[:service]

  warn = [true, "true", "1", 1].include? params[:warn]
  
  # Spec is undefined about what to do without these params, so redirecting to credential requestor
  redirect "/login", 303 unless username && password && login_ticket
  
  if username == "quentin" && password == "testpassword"
    if service_url && !warn
      redirect service_url, 303
    else
      haml :logged_in
    end
  else
    redirect "/login", 303
  end
end

get "/serviceValidate" do
  service_url = params[:service]
  
  # proxy_gateway = params[:pgtUrl]
  # renew = params[:renew]
  
  xml = if params[:service] && params[:ticket]
    if service_ticket
      if service_ticket.valid_for_service?(service_url)
        render_validation_success service_ticket.username
      else
        render_validation_error(:invalid_service)
      end
    else
      render_validation_error(:invalid_ticket)
    end
  else
    render_validation_error(:invalid_request)
  end
  
  content_type :xml
  xml.to_xml
end

private
def sso_session
  @sso_session ||= TicketGrantingTicket.validate!(request.cookies["tgt"], @redis)
end

def login_ticket
  @login_ticket ||= LoginTicket.validate!(params[:lt], @redis)
end

def service_ticket
  @service_ticket ||= ServiceTicket.validate!(params[:ticket], @redis)
end

def render_validation_error(code)
  Nokogiri::XML::Builder.new do |xml|
    xml.serviceResponse("xmlns" => "http://www.yale.edu/tp/cas") {
      xml.authenticationFailure(:code => code.to_s.upcase)
    }
  end
end

def render_validation_success(username)
  Nokogiri::XML::Builder.new do |xml|
    xml.serviceResponse("xmlns" => "http://www.yale.edu/tp/cas") {
      xml.authenticationSuccess {
        xml.user username
      }
    }
  end
end