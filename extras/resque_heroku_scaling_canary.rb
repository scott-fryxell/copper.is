require 'resque_heroku_scaling_canary'

Resque::Plugins::ScalingCanary.config do |config|
  config.heroku_app = "copper-#{ENV['RAILS_ENV']}"
  config.polling_interval = 3
  config.disable_scaling_if{ Rails.env == 'development' }
end
