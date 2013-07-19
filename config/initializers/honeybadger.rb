Honeybadger.configure do |config|
  config.api_key = 'ed4d9441'

  config.params_filters << "stripe_secret, twitter_secret, twitter_oauth_secret,
                            google_secret, facebook_secret, tumblr_secret, github_secret,
                            vimeo_secret, soundcloud_secret, flickr_secret, resque_overview_password"
end