module Channels
  class Github < Channel
    def self.site
      "github.com"
    end
    
    def you_have_tips_waiting(message)
    end
    
    def self.matcher(url)
      url =~ %r{github\.com\/[^/]+}
    end
    
    def self.extract(url)
      %r{github\.com\/([^/]+)}.match(url)[1] rescue nil
    end
  end
end
