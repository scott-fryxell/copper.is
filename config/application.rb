require File.expand_path('../boot', __FILE__)
require 'rails/all'

require 'open-uri'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Copper
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.cache_store = :dalli_store
    config.active_record.timestamped_migrations = false
    config.action_view.embed_authenticity_token_in_remote_forms = false
    config.active_record.whitelist_attributes= true

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/models/sites)

    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.1'
    config.assets.prefix = "/assets"

    config.assets.initialize_on_precompile= false

    %w[
      copper_secret_key

      stripe_key
      stripe_secret

      twitter_key
      twitter_secret
      twitter_oauth_key
      twitter_oauth_secret

      google_key
      google_secret

      facebook_key
      facebook_secret

      tumblr_key
      tumblr_secret

      github_key
      github_secret

      vimeo_key
      vimeo_secret

      soundcloud_key
      soundcloud_secret

      flickr_key
      flickr_secret

      google_code_developer_key
      resque_overview_password

      redistogo_url

    ].each do |env|
      # raise "#{env.to_s.upcase} must be defined" if ENV[env.to_s.upcase].blank?
      config.send(env.to_s + '=', ENV[env.to_s.upcase])
    end
  end
end
