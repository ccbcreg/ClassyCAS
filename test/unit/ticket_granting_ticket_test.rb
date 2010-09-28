require File.dirname(__FILE__) + "/../test_helper"
require 'lib/ticket_granting_ticket'

class TicketGrantingTicketTest < Test::Unit::TestCase
  context "A TicketGrantingTicket" do
    setup do
      @redis = Redis.new
      @tgt = TicketGrantingTicket.new("quentin")
      @tgt.save!(@redis)
    end
    # Most tests are in test/protocol.  Tests here are outside of the protocol, but are necessary anyway.
    
    should "be able to retrieve the username" do
      assert_equal("quentin", @tgt.username)

      tgt2 = TicketGrantingTicket.validate!(@tgt.ticket, @redis)
      assert_equal("quentin", @tgt.username)
    end
    
    should "return a ticket" do
      assert_not_nil @tgt.ticket
    end
  end
end