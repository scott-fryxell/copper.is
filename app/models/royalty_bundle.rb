class RoyaltyBundle < ActiveRecord::Base
  has_many :tip_royalties
  has_and_belongs_to_many :sites
  has_and_belongs_to_many :pages

  validates_numericality_of :cycle_started_year, :only_integer => true, :greater_than => 2008
  validates_numericality_of :cycle_started_quarter, :only_integer => true, :greater_than => 0, :less_than => 5

  def total_amount_in_cents
    tip_royalties.sum('amount_in_cents')
  end
end
