class RoyaltyOrder < ActiveRecord::Base
  has_many :royalties
  has_many :tip_orders, :foreign_key => "fan_id",:dependent => :destroy
  has_one :author, :foreign_key => 'author_id', :through => :page 
  has_one :identity, :through => :page
  
  has_and_belongs_to_many :pages
  validates_numericality_of :cycle_started_year, :only_integer => true, :greater_than => 2008
  validates_numericality_of :cycle_started_quarter, :only_integer => true, :greater_than => 0, :less_than => 5

  def total_amount_in_cents
    royalties.sum('amount_in_cents')
  end
end
