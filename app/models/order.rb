class Order < ActiveRecord::Base
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
        raise e
      end
    end
  end
  
  def send_paid_order_message card_number
    m = Mandrill::API.new(Copper::Application.config.mandrill_key)
    m.messages 'send-template', {
      template_name: "order reciept",
      template_content: [
        { name: "order_id",
          content: "#{self.id}"
        },
        { name: "order_total",
          content: "$#{self.total_in_dollars}"
        },
        { name: "order_date",
          content: "#{self.updated_at.strftime('%m/%d/%Y')}"
        },
        { name: "order_credit_card_number",
          content: "#{card_number}"
        },
        { name: "order_subtotal",
          content: "$#{self.subtotal_in_dollars}"
        },
        { name: "order_fee",
          content: "$#{self.fees_in_dollars}"
        },
        { name: "order_tips",
          content: self.tips_to_table_rows
        }
      ],
      message: {
        subject:"Your Receipt for order number #{self.id}",
        from_email: "us@copper.is",
        from_name: "The Copper Team",
        to:[{email:self.user.email, name:self.user.name}]
      }
    }
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
