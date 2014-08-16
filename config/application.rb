require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'open-uri'


Bundler.require(:default, Rails.env)

module Copper
  class Application < Rails::Application

    config.sass.load_paths += %w(vendor lib).map {|l| Rails.root.join(l, 'assets', 'stylesheets') }

    config.encoding = "utf-8"
    config.cache_store = :dalli_store
    config.active_record.timestamped_migrations = false
    config.action_view.embed_authenticity_token_in_remote_forms = false

    config.autoload_paths += %W(#{config.root}/lib)

    config.filter_parameters += [:password]

    config.assets.prefix = "/assets"

    config.assets.initialize_on_precompile=false
    config.action_dispatch.cookies_serializer = :json


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
      google_code_developer_key

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

      resque_overview_password

      redistogo_url
      mandrill_key

      mixpanel_key

    ].each do |env|
      raise "#{env.to_s.upcase} must be defined" if ENV[env.to_s.upcase].blank?
      config.send(env.to_s + '=', ENV[env.to_s.upcase])
    end
  end
end
