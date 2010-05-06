# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :sendmail

#braintree password: tipper123

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test

# Paypal connection, not using currently
#  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
#    :login => "seller_1267471128_biz@mybuys.com",
#    :password => "1267471138",
#    :signature => "Ad9B4K7zA-eD3NMvld9hoLQ6SpgnAqDy-CilXFJL9ZcD43sleNm0Oxp1"
#  )
  
  ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
	  :login => "9WBbf95f",
	  :password => "98VkFr5mDM292kfu",
	  :test => true
	)
end
