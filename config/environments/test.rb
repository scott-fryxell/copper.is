Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = true
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.assets.compress = true
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = true
  config.assets.debug = true
  config.assets.digest = false
  config.log_level = :debug
  config.hostname = "https://copper.is"
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:twitter] = {
    'provider' => 'twitter',
    'uid' => '123545',
    'username' => 'copper_is',
    'info' => {
      'name' => 'copper_is',
      'email' => 'user@twitter.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'twitter magic'
    }
  }
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '234567',
    'info' => {
      'name' => 'facebook user',
      'email' => 'user@facebook.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'facebook magic'
    }
  }
  OmniAuth.config.mock_auth[:google_oauth2] = {
    'provider' => 'google_oauth2',
    'uid' => '234567',
    'info' => {
      'name' => 'google user',
      'email' => 'user@google.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'google magic'
    }
  }
  OmniAuth.config.mock_auth[:tumblr] = {
    'provider' => 'tumblr',
    'uid' => '234567',
    'info' => {
      'name' => 'tumblr user',
      'email' => 'user@tumblr.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'tumblr magic'
    }
  }
  OmniAuth.config.mock_auth[:github] = {
    'provider' => 'github',
    'uid' => '3456789',
    'info' => {
      'name' => 'github user',
      'email' => 'user@github.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'github magic'
    }
  }
  OmniAuth.config.mock_auth[:vimeo] = {
    'provider' => 'vimeo',
    'uid' => '3456789',
    'info' => {
      'name' => 'vimeo user',
      'email' => 'user@vimeo.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'vimeo magic'
    }
  }
  OmniAuth.config.mock_auth[:soundcloud] = {
    'provider' => 'soundcloud',
    'uid' => '3456789',
    'info' => {
      'name' => 'soundcloud user',
      'email' => 'user@soundcloud.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'soundcloud magic'
    }
  }
  OmniAuth.config.mock_auth[:flickr] = {
    'provider' => 'flickr',
    'uid' => '3456789',
    'info' => {
      'name' => 'flickr user',
      'email' => 'user@flickr.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com'
    },
    'credentials' => {
      'token' => '666_777_666',
      'secret' => 'its_a_secret'
    },
    'extra' => {
      'user_hash' => 'flickr magic'
    }
  }

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

end
