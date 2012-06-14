module Channels
  class Github < Channel
    def self.scrape_for_address(doc)
      doc.css('a').map{|e| e.attr(:href)}.grep(/\/github\.com\/.+\//).last
    end
    
    def self.match?(channel)
      channel.address =~ /\/github\.com\// 
    end
  end
end
