Rails.application.config.middleware.use OmniAuth::Builder do

  # provider :developer unless Rails.env.production?

  provider :twitter, Copper::Application.config.twitter_consumer_key, Copper::Application.config.twitter_consumer_secret
  provider :facebook, Copper::Application.config.facebook_app_id, Copper::Application.config.facebook_app_secret, {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  # provider :google, Copper::Application.config.google_consumer_key, Copper::Application.config.google_consumer_secret
  provider :google_oauth2, Copper::Application.config.google_consumer_key, Copper::Application.config.google_consumer_secret, {access_type: 'online', approval_prompt: ''}

end