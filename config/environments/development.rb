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
config.action_mailer.default_url_options = { :host => "0.0.0.0", :port => 3000, :protocol => 'http' }
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :sendmail

#braintree password: tipper123

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test

# Braintree sandbox account
  ::GATEWAY = ActiveMerchant::Billing::BraintreeGateway.new(
    :environment  => :sandbox,
    :merchant_id  => "4hg2r8h74wh586qq",
    :public_key   => "2t58wq6qs4cz8d8k",
    :private_key  => "vyd3fmwsmnnxrm42",
    :test         => true
  )

# Paypal connection, not currently using
  # ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  #   :login => "seller_1267471128_biz@mybuys.com",
  #   :password => "1267471138",
  #   :signature => "Ad9B4K7zA-eD3NMvld9hoLQ6SpgnAqDy-CilXFJL9ZcD43sleNm0Oxp1"
  # )

# Authorize.net connection, not currently using
  # ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
  #   :login => "9WBbf95f",
  #   :password => "98VkFr5mDM292kfu",
  #   :test => true
  # )

end
