class TipBundleMissing < Exception ; end
class InsufficientFunds < Exception ; end

class TipBundle < ActiveRecord::Base
  has_many :refills
  has_many :tips

  belongs_to :billing_period
  belongs_to :fan, :class_name => "User", :foreign_key => "fan_id"

  validates_presence_of :fan
  validates_presence_of :refills, :on => :update
  validates_presence_of :billing_period

  validates_uniqueness_of :fan_id, :scope => :is_active, :if => :is_active

  def allocated_funds
    refills.sum('amount_in_cents')
  end

  def tip_points
    tips.sum('multiplier')
  end

  def cents_per_tip_point
    allocated_funds / tip_points
  end
end
