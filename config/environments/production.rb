DirtyWhiteCouch::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.serve_static_assets = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
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
