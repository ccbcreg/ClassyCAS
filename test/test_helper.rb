$:.unshift(File.dirname(__FILE__) + "/../")

require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'ruby-debug'
require 'redis'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

