class Order < ActiveRecord::Base
  include Enqueueable
  include Fan::Billable
  include Historicle

  has_many :tips
  belongs_to :user,  touch:true

  validates :user, presence:true
  validates_associated :user

  scope :current, -> { where(order_state:'current') }
  scope :unpaid,  -> { where(order_state:'unpaid')  }
  scope :denied,  -> { where(order_state:'denied')  }
  scope :paid,    -> { where(order_state:'paid')    }

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
      def rotate!
        process!
      end

      def billable?
        if tips.count > 0 and tips.sum(:amount_in_cents) > 50
          true
        else
          false
        end
      end
    end

    state :unpaid, :denied do
      def charge!
        stripe_charge = Stripe::Charge.create(
          :amount => subtotal() + fees(),
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
        send_paid_order_message stripe_charge.card['last4']
      rescue Stripe::CardError => e
        decline!
        if e.code == 'expired_card'
          user.message_
        end

        raise e
      end
    end
  end

  def subtotal
    self.tips.sum(:amount_in_cents)
  end

  def subtotal_in_dollars
    subtotal = Float(self.subtotal) / 100
    sprintf('%.2f', subtotal)
  end

  def fees
    self.tips.sum(:amount_in_cents) / 10
  end

  def fees_in_dollars
    fees = Float(self.fees) / 100
    sprintf('%.2f', fees)
  end

  def fees
    self.tips.sum(:amount_in_cents) / 10
  end

  def total
    self.subtotal + self.fees
  end

  def total_in_dollars
    sprintf('%.2f', Float(self.total)/100)
  end

end
