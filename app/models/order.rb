class Order < ActiveRecord::Base
  has_many :tips, :dependent => :destroy
  belongs_to :user

  validates :user, presence:true
  validates_associated :user

  scope :current, where('state = ?', 'current')
  scope :unpaid, where('state = ?', 'unpaid').order('created_at DESC')
  scope :denied, where('state = ?', 'denied')
  scope :paid, where('state = ?', 'paid')

  state_machine :state, :initial => :current do
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
        if ( self.tiped_enough_to_pay? && !self.user.automatic_rebill )
          return true
        else
          return false
        end
      end

      def tiped_enough_to_pay?
        self.tips.sum(:amount_in_cents) >= 1000
      end

    end

    state :unpaid,:denied do
      def charge!
        unless paid?
          begin
            stripe_charge = Stripe::Charge.create(
              :amount => subtotal() +fees(),
              :currency => "usd",
              :customer => self.user.stripe_customer_id,
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
        else
          raise "There was an attempt to charge! a paid Order: #{self.inspect}"
        end
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
