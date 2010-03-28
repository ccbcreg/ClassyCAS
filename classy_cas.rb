require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'
require 'addressable/uri'

require 'lib/login_ticket'
require 'lib/proxy_ticket'
require 'lib/service_ticket'
require 'lib/ticket_granting_ticket'

before do
  @redis = Redis.new
end

get "/login" do
  @service_url = Addressable::URI.parse(params[:service])
  
  if sso_session
    if @service_url
      st = ServiceTicket.new(@service_url)
      redirect_url = @service_url.clone
      redirect_url.query_values = @service_url.query_values.merge(:ticket => st.ticket)
      
      redirect redirect_url.to_s, 303
    else
      return haml :already_logged_in
    end
  end
  
  haml :login
end

post "/login" do
  username = params[:username]
  password = params[:password]
  login_ticket = params[:lt]
  
  service_url = params[:service]

  warn = ["1", "true"].include? params[:warn]
  
  # Spec is undefined about what to do without these params, so redirecting to credential requestor
  redirect "/login", 303 unless username && password && login_ticket
  
  if username == "quentin" && password == "testpassword"
    if service_url && !warn
      redirect service_url, 303
    else
      haml :logged_in
    end
  else
    
  end
end

private
def sso_session
  @sso_session ||= TicketGrantingTicket.validate!(request.cookies["tgt"], @redis)
end