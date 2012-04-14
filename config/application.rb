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

    config.action_view.embed_authenticity_token_in_remote_forms = false
    config.active_record.whitelist_attributes= true

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

    config.vimeo_key = ENV['VIMEO_KEY']
    config.vimeo_secret = ENV['VIMEO_SECRET']

    config.soundcloud_key = ENV['SOUNDCLOUD_KEY']
    config.soundcloud_secret = ENV['SOUNDCLOUD_SECRET']
    
    config.flickr_key = ENV['FLICKR_KEY']
    config.flickr_secret = ENV['FLICKR_SECRET']

    raise "Twitter key must be defined ENV['TWITTER_KEY']" unless Copper::Application.config.twitter_key
    raise "Twitter secret must be defined ENV['TWITTER_SECRET']" unless Copper::Application.config.twitter_secret

    raise "Google key must be defined ENV['GOOGLE_KEY']" unless Copper::Application.config.google_key
    raise "Google secret key must be defined ENV['GOOGLE_SECRET']" unless Copper::Application.config.google_secret

    raise "facebook key must be defined ENV['FACEBOOK_KEY']" unless Copper::Application.config.facebook_key
    raise "facebook secret key must be defined ENV['FACEBOOK_SECRET']" unless Copper::Application.config.facebook_secret

    raise "tumblr key must be defined ENV['TUMBLR_KEY']" unless Copper::Application.config.tumblr_key
    raise "tumblr secret key must be defined ENV['TUMBLR_SECRET']" unless Copper::Application.config.tumblr_secret

    raise "github key must be defined ENV['GITHUB_KEY']" unless Copper::Application.config.github_key
    raise "github secret key must be defined ENV['GITHUB_SECRET']" unless Copper::Application.config.github_secret

    raise "vimeo key must be defined ENV['VIMEO_KEY']" unless Copper::Application.config.vimeo_key
    raise "vimeo secret key must be defined ENV['VIMEO_SECRET']" unless Copper::Application.config.vimeo_secret

    raise "soundcloud key must be defined ENV['SOUNDCLOUD_KEY']" unless Copper::Application.config.soundcloud_key
    raise "soundcloud secret key must be defined ENV['SOUNDCLOUD_SECRET']" unless Copper::Application.config.soundcloud_secret

    raise "flickr key must be defined ENV['FLICKR_KEY']" unless Copper::Application.config.flickr_key
    raise "flickr secret key must be defined ENV['FLICKR_SECRET']" unless Copper::Application.config.flickr_secret


    raise "stripe publishable key must be defined ENV['STRIPE_KEY']" unless Copper::Application.config.stripe_key
    raise "stripe secret key must be defined ENV['STRIPE_SECRET']" unless Copper::Application.config.stripe_secret

    raise "session key must be defined ENV['COPPER_SECRET_KEY']" unless Copper::Application.config.copper_session_key
  end
end
