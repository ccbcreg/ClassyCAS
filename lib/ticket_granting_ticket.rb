class TicketGrantingTicket
  class << self
    def validate!(ticket, store)
      if store.key? ticket
        store.delete ticket
        new
      end
    end
  end
  
  def ticket
    @ticket ||= "TGC-#{rand(100000000000000000)}".to_s
  end
  
  def save!(store)
    store[ticket] = 1
  end

  def to_cookie(domain, path = "/")
    ["tgt", {
      :value => ticket,
      :domain => domain,
      :path => path
    }]
  end
end