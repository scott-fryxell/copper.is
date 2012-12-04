class Order < ActiveRecord::Base
  has_many :tips, :dependent => :destroy
  belongs_to :user
  has_paper_trail
  validates :user, presence:true
  validates_associated :user

  scope :current, where('order_state = ?', 'current')
  scope :unpaid, where('order_state = ?', 'unpaid')
  scope :denied, where('order_state = ?', 'denied')
  scope :paid, where('order_state = ?', 'paid')

  state_machine :order_state, :initial => :current do
    event :process do
      transition :current => :unpaid,
                 [:unpaid,:denied] => :paid,
                 :paid => :paid
    end

    event :decline do
      transition [:current,:unpaid,:denied] => :denied,
                 :paid => :paid
    end

    state :current do
      def time_to_pay?
        if ( self.tiped_enough_to_pay? )
          return true
        else
          return false
        end
      end

      def tiped_enough_to_pay?
        self.tips.sum(:amount_in_cents) >= 1000
      end

    end
    
    state :current do
      def rotate!
        process!
      end
    end

    state :unpaid,:denied do
      def charge!
        stripe_charge = Stripe::Charge.create(
          :amount => subtotal() +fees(),
          :currency => "usd",
          :customer => self.user.stripe_id,
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
