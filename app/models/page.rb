class Page < ActiveRecord::Base

  has_many :locators
  has_many :tips, :through => :locators
  has_and_belongs_to_many :royalty_orders
  validates_presence_of :description

  attr_accessible :description
  # scope :old_most_tips, :include => [:tips], 
  #         :conditions => "tips.locator_id = locators.id", 
  #         :group => "pages.id", 
  #         :order => "count(tips.id) DESC"

  # select pages that have the most tips
  
  def revenue_earned
    royalty_orders.inject(0) { |sum, order| sum + order.royalties.sum('amount_in_cents') }
  end

  def primary_locator
    locators.first
  end
end
