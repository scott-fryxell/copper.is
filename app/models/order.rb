class Order < ActiveRecord::Base
  include Enqueueable
  include OrderMessages
  has_many :tips
  belongs_to :user,  touch:true
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


  def tips_to_table_rows
    tip_rows = ""
    self.tips.find_each do |tip|
      title = tip.title
      if title.length == 0
        title = tip.url
      end
      tip_rows += "<tr><td width='400'><a href='#{tip.url}'>#{title[0...75]}</a><br/></td><td>$#{tip.amount_in_dollars}</td></tr>"
    end
    tip_rows
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
