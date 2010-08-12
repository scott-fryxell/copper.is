class Order < ActiveRecord::Base
  attr_accessible :amount, :account_id
  has_many :transactions, :class_name => "OrderTransaction"
  belongs_to :account
  has_one :user, :through => :account

  validates_presence_of :amount_in_cents
  validates_numericality_of :amount_in_cents, :integer_only => true
  validates_presence_of :ip_address
  validates_format_of :ip_address, :with => /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/
  validates_presence_of :account_id
  validate_on_create :validate_card
  validate_on_update :validate_card

  def purchase
    response = GATEWAY.purchase(amount_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => amount_in_cents, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end

  private

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
    :number             => account.number,
    :verification_value => account.verification_code,
    :month              => account.expires_on.month,
    :year               => account.expires_on.year,
    :first_name         => account.billing_name.split(' ')[1],
    :last_name          => account.billing_name.split(' ')[2]
  )
  end

  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "#{account.billing_name}",
        :address1 => account.address.street1,
        :city     => account.address.city,
        :state    => account.address.state,
        :country  => account.address.country,
        :zip      => account.address.zip
      }
    }
  end
end
