module Channels
  class Twitter < Channel
    def you_have_tips_waiting(message_id)
    end
    
    def self.matcher(url)
      url =~ /twitter\.com/
    end
    
    def self.extract(url)
      /twitter\.com\/([^\/]+)/.match(a)[1] rescue nil
    end
    
    def self.auth
      true
    end
  end
end
