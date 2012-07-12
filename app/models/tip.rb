class Tip < ActiveRecord::Base
  has_paper_trail
  belongs_to :order
  
  after_create do |tip|
    Resque.enqueue Page::SpiderJob, tip.url
  end
end
