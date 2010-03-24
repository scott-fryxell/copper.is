class Order < ActiveRecord::Base
  attr_accessible :amount, :account_id
  has_many :transactions, :class_name => "OrderTransaction"
  belongs_to :account 
  has_one :user, :through => :account
  # validate_on_create :validate_card

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end

  def price_in_cents
    amount * 100
  end

  private

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end


  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
    :type               => account.card_type,
    :number             => account.number,
    :verification_value => account.verification_value,
    :month              => account.card_expires_on.month,
    :year               => account.card_expires_on.year,
    :first_name         => account.first_name,
    :last_name          => account.last_name
  )
  end

  def purchase_options
    {
      :ip => ip_address,  
      :billing_address => {
        :name     => "#{account.first_name} #{account.last_name}",
        :address1 => account.address.street1,
        :city     => account.address.city,
        :state    => account.address.state,
        :country  => account.address.country,
        :zip      => account.address.zip
      }
    }
  end
end
