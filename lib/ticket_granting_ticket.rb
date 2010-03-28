class TicketGrantingTicket
  class << self
    def validate!(ticket, store)
      if ticket && username = store[ticket]
        new(username)
      end
    end
  end
  
  attr_reader :username
  
  def initialize(user)
    @username = user
  end
    
  def ticket
    @ticket ||= "TGC-#{rand(100000000000000000)}".to_s
  end
  
  def save!(store)
    store[ticket] = username
  end

  def to_cookie(domain, path = "/")
    ["tgt", {
      :value => ticket,
      :domain => domain,
      :path => path
    }]
  end
end