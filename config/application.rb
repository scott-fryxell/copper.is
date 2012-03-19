require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Copper
  class Application < Rails::Application

    config.encoding = "utf-8"
    config.active_record.timestamped_migrations = false

    config.filter_parameters += [:password]

    config.autoload_paths += %W(#{config.root}/extras)
    config.active_record.timestamped_migrations = false

    config.assets.enabled = true

    config.assets.version = '1.0'

    config.assets.prefix = "/assets"

    config.assets.initialize_on_precompile= false

    config.twitter_consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.twitter_consumer_secret = ENV['TWITTER_CONSUMER_SECRET']

    config.google_consumer_key = ENV['GOOGLE_CONSUMER_KEY']
    config.google_consumer_secret = ENV['GOOGLE_CONSUMER_SECRET']

    config.facebook_app_id = ENV['FACEBOOK_APP_ID']
    config.facebook_app_secret = ENV['FACEBOOK_APP_SECRET']

    config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
    config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']

    config.copper_session_key = ENV['COPPER_SECRET_KEY']

    # config.email_password = ENV['EMAIL_PASSWORD']

    raise "Twitter consumer key must be defined ENV['TWITTER_CONSUMER_KEY']" unless Copper::Application.config.twitter_consumer_key
    raise "Twitter Consumer secret Name must be defined ENV['TWITTER_CONSUMER_SECRET']" unless Copper::Application.config.twitter_consumer_secret

    raise "Google consumer key must be defined ENV['GOOGLE_CONSUMER_KEY']" unless Copper::Application.config.google_consumer_key
    raise "Google Consumer secret Name must be defined ENV['GOOGLE_CONSUMER_SECRET']" unless Copper::Application.config.google_consumer_secret

    raise "facebook app id must be defined ENV['FACEBOOK_APP_ID']" unless Copper::Application.config.facebook_app_id
    raise "facebook secret key must be defined ENV['FACEBOOK_APP_SECRET']" unless Copper::Application.config.facebook_app_secret

    raise "stripe publishable key must be defined ENV['STRIPE_PUBLISHABLE_KEY']" unless Copper::Application.config.stripe_publishable_key
    raise "stripe secret key must be defined ENV['STRIPE_SECRET_KEY']" unless Copper::Application.config.stripe_secret_key

    raise "session key must be defined ENV['COPPER_SECRET_KEY']" unless Copper::Application.config.copper_session_key

    # raise "email password be defined ENV['EMAIL_PASSWORD']" unless Copper::Application.config.email_password

  end
end
