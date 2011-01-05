class TipBundleMissing < Exception ; end

class TipBundle < ActiveRecord::Base
  has_many :tips

  # belongs_to :billing_period
  belongs_to :fan, :class_name => "User", :foreign_key => "fan_id"

  validates_presence_of :fan

  # validates_presence_of :refills, :on => :update
  #   validates_presence_of :billing_period# TODO , :default => BillingPeriod.find(Time.now.day)
  #
  validates_uniqueness_of :fan_id, :scope => :is_active, :if => :is_active

  def total_in_cents
    tips.sum('amount_in_cents')
  end

end
