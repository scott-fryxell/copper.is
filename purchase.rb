require "rubygems"
require "active_merchant"

ActiveMerchant::Billing::Base.mode = :test

gateway = ActiveMerchant::Billing::BraintreeGateway.new(
  :environment  => :sandbox,
  :merchant_id  => "4hg2r8h74wh586qq",
  :public_key   => "2t58wq6qs4cz8d8k",
  :private_key  => "vyd3fmwsmnnxrm42",
  :test         => true
)

credit_card = ActiveMerchant::Billing::CreditCard.new(
  :type               => "visa",
  :number             => "4111111111111111",
  :verification_value => "123",
  :month              => 1,
  :year               => Time.now.year+1,
  :first_name         => "Princess",
  :last_name          => "Nell"
)

if credit_card.valid?
  response = gateway.authorize(1000, credit_card, :ip => "127.0.0.1")
  if response.success?
    gateway.capture(1000, response.authorization)
    puts "Purchase complete!"
  else
    puts "Error: #{response.message}"
  end
else
  puts "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
end
