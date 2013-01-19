Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress = false
  config.assets.debug = true
  config.hostname = "http://copper.dev"
  config.log_level = :info
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.25
  # ActiveRecord::Base.logger.level = 1 if defined? ActiveRecord::Base
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'copper.is',
    :user_name            => 'scott@copper.is',
    :password             => ENV['EMAIL_PASSWORD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
end
