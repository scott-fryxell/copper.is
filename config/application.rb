require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env) if defined?(Bundler)

module DirtyWhiteCouch
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, )) ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    config.active_record.timestamped_migrations = false
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.autoload_paths += %W(#{config.root}/extras)
    config.active_record.timestamped_migrations = false

    config.twitter_consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.twitter_consumer_secret = ENV['TWITTER_CONSUMER_SECRET']

    config.facebook_app_id = ENV['FACEBOOK_APP_ID']
    config.facebook_app_secret = ENV['FACEBOOK_APP_SECRET']

    config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
    config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']

    config.dwc_session_key = ENV['DWC_SECRET_KEY']

    config.email_password = ENV['EMAIL_PASSWORD']

    raise "Twitter consumer key must be defined ENV['TWITTER_CONSUMER_KEY']" unless DirtyWhiteCouch::Application.config.twitter_consumer_key
    raise "Twitter Consumer secret Name must be defined ENV['TWITTER_CONSUMER_SECRET']" unless DirtyWhiteCouch::Application.config.twitter_consumer_secret

    raise "facebook app id must be defined ENV['FACEBOOK_APP_ID']" unless DirtyWhiteCouch::Application.config.facebook_app_id
    raise "facebook secret key must be defined ENV['FACEBOOK_APP_SECRET']" unless DirtyWhiteCouch::Application.config.facebook_app_secret

    raise "stripe publishable key must be defined ENV['STRIPE_PUBLISHABLE_KEY']" unless DirtyWhiteCouch::Application.config.stripe_publishable_key
    raise "stripe secret key must be defined ENV['STRIPE_SECRET_KEY']" unless DirtyWhiteCouch::Application.config.stripe_secret_key

    raise "session key must be defined ENV['DWC_SESSION_KEY']" unless DirtyWhiteCouch::Application.config.dwc_session_key

    raise "email password be defined ENV['EMAIL_PASSWORD']" unless DirtyWhiteCouch::Application.config.email_password


  end
end
