Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :twitter, DirtyWhiteCouch::Application.config.twitter_consumer_key, DirtyWhiteCouch::Application.config.twitter_consumer_secret
  provider :facebook, DirtyWhiteCouch::Application.config.facebook_app_id, DirtyWhiteCouch::Application.config.facebook_app_secret
end