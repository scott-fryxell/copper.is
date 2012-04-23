class TipOrderMissing < Exception ; end

class TipOrder < ActiveRecord::Base
  has_many :tips, :dependent => :destroy
  belongs_to :user
  
  validates :user, presence:true
  validates_associated :user
  
  scope :current, where('state = ?', 'current')
  scope :paid, where('state = ?', 'paid')
  scope :declined, where('state = ?', 'declined')

  state_machine :state, :initial => :current do
    event :prepare do
      transition :current => :ready, :if => lambda {|tip_order| tip_order.user.charge_info? }
    end
    
    after_transition :current => :ready do |tip_order,transition|
      tip_order.user.tip_orders.current.create
    end
    
    event :process do
      transition all - :paid => :paid, :if => lambda {|tip_order| tip_order.send(:charge) }
    end
    
    event :decline do
      transition :ready => :declined
    end
  end
  
  def time_to_pay?
    if ( self.tiped_enough_to_pay? && !self.user.automatic_rebill )
      return true
    else
      return false
    end
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

  protected 
  
  def charge
    stripe_charge = Stripe::Charge.create(
      :amount => self.tips.sum('amount_in_cents') + self.tips.sum('amount_in_cents')/10,
      :currency => "usd",
      :customer => self.user.stripe_customer_id,
      :description => self.user.email
    )
    self.charge_token = stripe_charge.id
    self.save!
    self.tips.find_each do |tip|
      tip.pay!
    end
    stripe_charge
  rescue Stripe::CardError => e
    self.decline
    nil
  end
end
