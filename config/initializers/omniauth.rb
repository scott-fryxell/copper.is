Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :twitter, Copper::Application.config.twitter_key, Copper::Application.config.twitter_secret
  provider :facebook, Copper::Application.config.facebook_key, Copper::Application.config.facebook_secret, {:scope => 'email, offline_access, user_likes, publish_actions', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  provider :google_oauth2, Copper::Application.config.google_key, Copper::Application.config.google_secret, {:scope => 'http://gdata.youtube.com,userinfo.email,userinfo.profile,plus.me', :access_type => 'online', :approval_prompt => ''}
  provider :tumblr, Copper::Application.config.tumblr_key, Copper::Application.config.tumblr_secret  
  provider :github, Copper::Application.config.github_key, Copper::Application.config.github_secret
  provider :vimeo, Copper::Application.config.vimeo_key, Copper::Application.config.vimeo_secret
  provider :soundcloud, Copper::Application.config.soundcloud_key, Copper::Application.config.soundcloud_secret
  provider :flickr, Copper::Application.config.flickr_key, Copper::Application.config.flickr_secret
end