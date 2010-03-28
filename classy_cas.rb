require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

before do
  @redis = Redis.new
end

get "/login" do
  @service_url = params[:service]
  
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
  
end
