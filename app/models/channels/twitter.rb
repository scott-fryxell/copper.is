module Channels
  class Twitter < Channel
    def self.scrape_for_address(doc)
      doc.css('a').map{|e| e.attr(:href)}.grep(/\/twitter\.com\/.+/).last
    end
    
    def self.match?(channel)
      channel.address =~ /\/twitter\.com\// 
    end
  end
end
