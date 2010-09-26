require File.dirname(__FILE__) + "/../test_helper"
require 'lib/service_ticket'

class ServiceTicketTest < Test::Unit::TestCase
  context "A TicketGrantingTicket" do
    setup do
      @redis = Redis.new
      assert_not_nil @redis
      @st = ServiceTicket.new("http://localhost", "quentin")
      @st.save!(@redis)
    end
    # Most tests are in test/protocol.  Tests here are outside of the protocol, but are necessary anyway.
    
    should "be able to retrieve the username" do
      assert_equal("quentin", @st.username)
      assert_equal("http://localhost", @st.service_url)

      st2 = ServiceTicket.validate!(@st.ticket, @redis)
      assert_equal("quentin", st2.username)
      assert_equal("http://localhost", st2.service_url)
    end
  end
end