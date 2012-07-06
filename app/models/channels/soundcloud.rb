module Channels
  class Soundcloud < Channel
    def you_have_tips_waiting(message_id)
    end
    
    def self.site
      'soundcloud.com'
    end
    
    def self.matcher(url)
      url =~ /soundcloud\.com/
    end
    
    def self.extract(url)
      /soundcloud\.com\/([^\/]+)/.match(a)[1] rescue nil
    end
    
    def self.auth
      true
    end
  end
end
