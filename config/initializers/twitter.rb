Twitter.configure do |config|
  config.consumer_key = Copper::Application.config.twitter_key
  config.consumer_secret = Copper::Application.config.twitter_secret
  config.oauth_token = Copper::Application.config.twitter_oauth_key
  config.oauth_token_secret = Copper::Application.config.twitter_oauth_secret
end