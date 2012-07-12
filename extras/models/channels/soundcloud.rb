module Channels
  class Soundcloud < Channel
    def self.scrape_for_address(doc)
      doc.css('a').map{|e| e.attr(:href)}.grep(/\/soundcloud\.com\/.+/).last
    end
    
    def self.match?(channel)
      channel.address =~ /\/soundcloud\.com\// 
    end
  end
end
