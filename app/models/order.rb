class Order < ActiveRecord::Base
  has_paper_trail
  
  has_many :tips, :order => 'created_at', :dependent => :destroy
  belongs_to :fan
  
  validates :fan, presence:true

  scope :current, where('order_state = ?', 'current')
  scope :paid, where('order_state = ?', 'paid')
  scope :unpaid, where('order_state = ?', 'unpaid').order('created_at DESC')
  scope :denied, where('order_state = ?', 'denied')

  state_machine :order_state, :initial => :current do
    event :process do
      transition [:current,:unpaid,:denied] => :paid,
                 :paid => :paid
    end

    state :current, :unpaid,:denied do
      def charge!
        stripe_charge = Stripe::Charge.create(
          :amount => subtotal() + fees(),
          :currency => "usd",
          :customer => self.fan.stripe_customer_id,
          :description => "order.id=" + self.id.to_s
        )
        self.charge_token = stripe_charge.id
        self.save!
        self.tips.find_each do |tip|
          tip.pay!
        end
        process!
        stripe_charge
      rescue Stripe::CardError => e
        decline!
        raise e
      end
    end
    event :decline do
      transition [:current,:unpaid,:denied] => :denied,
      :paid => :paid
    end

    state :current do
      def time_to_pay?
        self.tiped_enough_to_pay? and !self.user.automatic_rebill
      end

      def tiped_enough_to_pay?
        self.tips.sum(:amount_in_cents) >= 1000 # TODO make a config option
      end
    end
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
end
