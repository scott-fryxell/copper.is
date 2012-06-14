class Channel < ActiveRecord::Base
  has_paper_trail
  belongs_to :page
  
  attr_accessible :site, :user
end
