Copper::Application.configure do
  config.eager_load = false
  config.cache_classes = false

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = true
  config.action_controller.allow_forgery_protection = true
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.assets.compress = false
  config.assets.compile = true
  config.assets.debug = false
  config.assets.digest = true
  config.log_level = :warn
  config.hostname = "http://0.0.0.0:3000"

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:twitter] = {
    'provider' => 'twitter',
    'uid' => '123545',
    'info' => {
      'name' => 'copper',
      'nickname'=> 'copper_is',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '580281278',
    'info' => {
      'name' => 'scott fryxell',
      'nickname'=> 'scott.fryxell',
      'email' => 'user@facebook.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }

  OmniAuth.config.mock_auth[:google_oauth2] = {
    'provider' => 'google_oauth2',
    'uid' => '234567',
    'info' => {
      'name' => 'google user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:tumblr] = {
    'provider' => 'tumblr',
    'uid' => '234567',
    'info' => {
      'name' => 'tumblr user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:github] = {
    'provider' => 'github',
    'uid' => '3456789',
    'info' => {
      'name' => 'github user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:vimeo] = {
    'provider' => 'vimeo',
    'uid' => '3456789',
    'info' => {
      'name' => 'vimeo user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:soundcloud] = {
    'provider' => 'soundcloud',
    'uid' => '3456789',
    'info' => {
      'name' => 'soundcloud user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }
  OmniAuth.config.mock_auth[:flickr] = {
    'provider' => 'flickr',
    'uid' => '3456789',
    'info' => {
      'name' => 'flickr user',
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
  }

end
