Rails.application.config.middleware.use OmniAuth::Builder do

  # provider :developer unless Rails.env.production?

  provider :twitter, DirtyWhiteCouch::Application.config.twitter_consumer_key, DirtyWhiteCouch::Application.config.twitter_consumer_secret
  provider :facebook, DirtyWhiteCouch::Application.config.facebook_app_id, DirtyWhiteCouch::Application.config.facebook_app_secret, {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  provider :google, DirtyWhiteCouch::Application.config.google_consumer_key, DirtyWhiteCouch::Application.config.google_consumer_secret

end