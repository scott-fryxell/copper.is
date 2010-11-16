# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test # TODO - set the mode to production when we go live

  ::GATEWAY = ActiveMerchant::Billing::BraintreeGateway.new(
    :environment  => :sandbox, # TODO - remove this line when going to production with Braintree
    :merchant_id  => "4hg2r8h74wh586qq",
    :public_key   => "2t58wq6qs4cz8d8k",
    :private_key  => "vyd3fmwsmnnxrm42",
    :test         => true # TODO - remove this line when going to production with Braintree
  )
  # ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
  #   :login => "9WBbf95f",
  #   :password => "98VkFr5mDM292kfu",
  #   :test => true # TODO - remove this line when we are actually going to production Authorize.net
  # )
end