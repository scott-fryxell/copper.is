class Order < ActiveRecord::Base
  has_many :order_transactions# , :class_name => "OrderTransaction"
  has_one :transaction # soon to be renamed payment
  belongs_to :account
  has_one :user, :through => :account

  validates_presence_of :amount_in_cents
  validates_numericality_of :amount_in_cents, :integer_only => true
  validates_presence_of :ip_address
  validates_format_of :ip_address,
                      :with => /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/,
                      :message => "not a valid IP address"
  validates_presence_of :account
  validates_associated :account
  validate :validate_card

  attr_accessible :amount_in_cents, :account_id
  attr_accessor :rebill

  def place_order
    if save
      if purchase
        create_payment! # TODO Need logging of the success of this method
        true
      else
        false
      end
    else
      false
    end
  end

  private

  def purchase
    response = GATEWAY.purchase(amount_in_cents, credit_card, purchase_options)
    order_transactions.create!(:action => "purchase", :amount_in_cents => amount_in_cents, :response => response)
    response.success?
  end

  def create_payment!
    self.transaction = Transaction.create(:amount_in_cents => amount_in_cents, :account => account)
    self.transaction.split_refill_and_fee
    self.transaction
  end

  def validate_card
    if account
      unless credit_card.valid?
        credit_card.errors.full_messages.each do |message|
          errors.add_to_base message
        end
      end
    else
      errors.add_to_base("no account associated with this order")
    end
  end


  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
    :type               => account.card_type.name,
    :number             => account.number.to_s(),
    :verification_value => account.verification_code.to_s(),
    :month              => account.expires_on.month,
    :year               => account.expires_on.year,
    :first_name         => account.billing_name.split(' ')[0],
    :last_name          => account.billing_name.split(' ')[1]
  )
  end

  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => account.billing_name,
        :address1 => account.billing_address.line_1,
        :city     => account.billing_address.city,
        :state    => account.billing_address.state,
        :country  => account.billing_address.country,
        :zip      => account.billing_address.postal_code
      }
    }
  end

end
