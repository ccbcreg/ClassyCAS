class ServiceTicket
  class << self
    def validate!(ticket, store)
      username, service_url = store.lrange(ticket, 0,1)
      
      if service_url && username
        store.delete ticket
        new(service_url, username)
      end
    end
    
    def expire_time
      300
    end
  end
  
  attr_reader :username, :service_url
  
  def initialize(service_url, username)
    @service_url = service_url
    @username = username
  end
  
  def valid_for_service?(url)
    service_url == url
  end
  
  def ticket
    @ticket ||= "ST-#{rand(100000000000000000)}".to_s
  end
  
  def remaining_time(store)
    store.ttl ticket
  end
  
  def save!(store)
    # Look at switching to HSET when it's implemented, for now, a 2 member list will do
    store.pipelined do |pl|
      pl.lpush ticket, service_url
      pl.lpush ticket, username
      pl.expire ticket, self.class.expire_time
    end
  end
end