require "rubygems"
require "active_merchant"
 
ActiveMerchant::Billing::Base.mode = :test

gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
  :login => "9WBbf95f",
  :password => "98VkFr5mDM292kfu",
  :test => true
)
 
credit_card = ActiveMerchant::Billing::CreditCard.new(
  :type               => "visa",
  :number             => "4024007148673576",
  :verification_value => "123",
  :month              => 1,
  :year               => Time.now.year+1,
  :first_name         => "Ryan",
  :last_name          => "Bates"
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