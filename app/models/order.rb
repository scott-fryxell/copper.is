# == Schema Information
# Schema version: 20100309235816
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  card_type       :string(255)
#  card_expires_on :date
#  created_at      :datetime
#  updated_at      :datetime
#  ip_address      :string(255)
#  amount          :decimal(, )
#

class Order < ActiveRecord::Base
  has_many :transactions, :class_name => "OrderTransaction"
  belongs_to  :user
  has_one  :account
  
  validate_on_create :validate_card

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end

  def price_in_cents
    amount * 1000
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
    :number             => account.card_number,
    :verification_value => account.card_verification,
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
          :name     => "Ryan Bates",
          :address1 => "123 Main St.",
          :city     => "New York",
          :state    => "NY",
          :country  => "US",
          :zip      => "10001"
        }
      }
  end
    
end
