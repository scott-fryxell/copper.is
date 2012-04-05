class TipOrderMissing < Exception ; end

class TipOrder < ActiveRecord::Base
  extend Resque::Plugins::ScalingCanary
  
  has_many :tips, :dependent => :destroy
  belongs_to :fan, :class_name => "User", :foreign_key => "fan_id"
  validates_presence_of :fan
  validates_uniqueness_of :fan_id, :scope => :is_active, :if => :is_active
  attr_accessible :fan, :is_active

  def time_to_pay?
    if ( self.tiped_enough_to_pay? && !self.fan.automatic_rebill )
      return true
    else
      return false
    end
  end
  def charge

    charge = Stripe::Charge.create(
      :amount => self.tips.sum('amount_in_cents') + self.tips.sum('amount_in_cents')/10,
      :currency => "usd",
      :customer => self.fan.stripe_customer_id,
      :description => self.fan.email
    )

    self.charge_token = charge.id
    self.save

    # on success rotate order so that no
    # more tips are added to the order
    self.fan.rotate_tip_order!

    return charge
  end
  def tiped_enough_to_pay?
    self.tips.sum(:amount_in_cents) >= 1000
  end
  def subtotal
    self.tips.sum(:amount_in_cents)
  end
  def fees
    self.tips.sum(:amount_in_cents)/10
  end
  def total
    self.subtotal + self.fees
  end
  def self.minimum_workers_needed
    Copper::Application.copper.tip_order_min_workers || 2
  end
  def self.perform
    raise 'TBD'
  end
end
