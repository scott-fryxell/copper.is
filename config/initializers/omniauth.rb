Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :twitter, DirtyWhiteCouch::Application.config.twitter_consumer_secret, DirtyWhiteCouch::Application.config.twitter_consumer_secret
end