# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

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
  ActiveMerchant::Billing::Base.mode = :test
  # TODO - set the mode to production when we are actually going to production
  
  # Paypal, not using currently
#  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
#    :login => "seller_1229899173_biz_api1.railscasts.com",
#    :password => "FXWU58S7KXFC6HBE",
#    :signature => "AGjv6SW.mTiKxtkm6L9DcSUCUgePAUDQ3L-kTdszkPG8mRfjaRZDYtSu"
#  )

	::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
	  :login => "9WBbf95f",
	  :password => "98VkFr5mDM292kfu",
	  :test => true # TODO - remove this line when we are actually going to production Authorize.net
	)
	
end