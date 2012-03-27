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

    config.copper_session_key = ENV['COPPER_SECRET_KEY']

    config.stripe_key = ENV['STRIPE_KEY']
    config.stripe_secret = ENV['STRIPE_SECRET']

    config.twitter_key = ENV['TWITTER_KEY']
    config.twitter_secret = ENV['TWITTER_SECRET']

    config.google_key = ENV['GOOGLE_KEY']
    config.google_secret = ENV['GOOGLE_SECRET']

    config.facebook_key = ENV['FACEBOOK_KEY']
    config.facebook_secret = ENV['FACEBOOK_SECRET']

    config.tumblr_key = ENV['TUMBLR_KEY']
    config.tumblr_secret = ENV['TUMBLR_SECRET']

    config.github_key = ENV['GITHUB_KEY']
    config.github_secret = ENV['GITHUB_SECRET']

    raise "Twitter consumer key must be defined ENV['TWITTER_KEY']" unless Copper::Application.config.twitter_key
    raise "Twitter Consumer secret Name must be defined ENV['TWITTER_SECRET']" unless Copper::Application.config.twitter_secret

    raise "Google consumer key must be defined ENV['GOOGLE_KEY']" unless Copper::Application.config.google_key
    raise "Google Consumer secret Name must be defined ENV['GOOGLE_SECRET']" unless Copper::Application.config.google_secret

    raise "facebook app id must be defined ENV['FACEBOOK_KEY']" unless Copper::Application.config.facebook_key
    raise "facebook secret key must be defined ENV['FACEBOOK_SECRET']" unless Copper::Application.config.facebook_secret

    raise "tumblr key must be defined ENV['TUMBLR_KEY']" unless Copper::Application.config.tumblr_key
    raise "tumblr secret key must be defined ENV['TUMBLR_SECRET']" unless Copper::Application.config.tumblr_secret

    raise "github key must be defined ENV['GITHUB_KEY']" unless Copper::Application.config.github_key
    raise "github secret key must be defined ENV['GITHUB_SECRET']" unless Copper::Application.config.github_secret

    raise "stripe publishable key must be defined ENV['STRIPE_KEY']" unless Copper::Application.config.stripe_key
    raise "stripe secret key must be defined ENV['STRIPE_SECRET']" unless Copper::Application.config.stripe_secret

    raise "session key must be defined ENV['COPPER_SECRET_KEY']" unless Copper::Application.config.copper_session_key

  end
end
