$:.unshift(File.dirname(__FILE__) + "/../")

require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'ruby-debug'
require 'redis'
require "rack/test"
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

Shoulda::ClassMethods.module_eval do
  alias :must :should
  alias :may :should
end

module Test::Unit::Assertions
  def assert_false(object, message="")
    assert_equal(false, object, message)
  end
end