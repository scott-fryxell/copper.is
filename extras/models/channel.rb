class Channel < ActiveRecord::Base
  include STIFactory
  
  attr_accessible :address, :type
  
  def self.spider(author_id,page_id)
    # if Page.find(page_id).author.channels.count > 0
      
    # end  
  end
end
