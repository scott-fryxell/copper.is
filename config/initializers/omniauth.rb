Rails.application.config.middleware.use OmniAuth::Builder do

  # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
  require 'openid/store/filesystem'

  # provider :developer unless Rails.env.production?
  provider :twitter, DirtyWhiteCouch::Application.config.twitter_consumer_key, DirtyWhiteCouch::Application.config.twitter_consumer_secret
  provider :facebook, DirtyWhiteCouch::Application.config.facebook_app_id, DirtyWhiteCouch::Application.config.facebook_app_secret, {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}

  # generic openid
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'

  # dedicated openid
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
  # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com

end