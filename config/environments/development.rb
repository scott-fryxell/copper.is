DirtyWhiteCouch::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress = false
  config.assets.debug = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'dirtywhitecouch.com',
    :user_name            => 'scott@dirtywhitecouch.com',
    :password             => DirtyWhiteCouch::Application.config.email_password,
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
end