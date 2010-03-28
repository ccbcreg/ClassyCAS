require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

before do
  @redis = Redis.new
end

get "/login" do
  haml :login
end
