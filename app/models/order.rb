class OrderDeclined < Exception ; end

class Order < ActiveRecord::Base
  has_many :tips, :dependent => :destroy
  belongs_to :user
  
  validates :user, presence:true
  validates_associated :user
  
  scope :unpaid, where('state = ?', 'unpaid').order('created_at DESC')
  scope :declined, where('state = ?', 'declined')
  scope :paid, where('state = ?', 'paid')

  state_machine :state, :initial => :unpaid do
    event :process do
      transition [:unpaid,:declined] => :paid
    end
    
    event :decline do
      transition [:unpaid,:declined] => :declined
    end
    
    before_transition [:unpaid,:declined] => :paid do |order,transition|
      order.charge!
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

  def charge!
    unless paid?
      begin
        stripe_charge = Stripe::Charge.create(
          :amount => subtotal() +fees(),
          :currency => "usd",
          :customer => self.user.stripe_customer_id,
          :description => self.user.email
        )
        self.charge_token = stripe_charge.id
        # self.save!
        self.tips.find_each do |tip|
          tip.pay!
        end
        stripe_charge
      rescue Stripe::CardError => e
        self.decline!
        raise OrderDeclined
      end 
    else
      raise "There was an attempt to charge! a paid Order: #{self.inspect}"
    end
  end
end
