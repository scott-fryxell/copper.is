Copper::Application.configure do
  config.force_ssl = true
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.assets.compress = true
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = true
  config.assets.debug = false
  config.assets.digest = true
  config.action_controller.asset_host = "d1qlg1mi5h09s2.cloudfront.net"
  config.hostname = "https://copper-stage.herokuapp.com"
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=31536000"
  config.action_dispatch.rack_cache = {
    :metastore    => Dalli::Client.new,
    :entitystore  => 'file:tmp/cache/rack/body',
    :allow_reload => false
  }

  config.active_record.mass_assignment_sanitizer = :strict

  config.active_record.auto_explain_threshold_in_seconds = 0.5

  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp

end
