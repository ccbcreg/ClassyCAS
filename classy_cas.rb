require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

before do
  @redis = Redis.new
end

get "/login" do
  @service_param = params[:service]
  
  haml :login
end
