module Channels
  class Rubygems < Channel
    def self.site
      'rubygems.org'
    end
    
    def self.matcher(url)
      url =~ /rubygems\.org/
    end
    
    def self.extract(url)
      /rubygems\.org\/(profiles\/[0-9]+)/.match(a)[1] rescue nil
    end
  end
end
