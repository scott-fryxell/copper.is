Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = true
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.assets.compress = false
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = true
  config.assets.debug = true
  config.assets.digest = false
  config.log_level = :info
  config.hostname = "http://127.0.0.1:8080"
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
    'uid' => '234567',
    'info' => {
      'name' => 'facebook user',
      'nickname'=> 'facebook.user',
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

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

end
