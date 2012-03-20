Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:twitter] = {
    'provider' => 'twitter',
    'uid' => '123545',
    'info' => {
      'name' => 'twitter user',
      'email' => 'user@twitter.com',
      'image' => 'http://image.com/me.png',
      'location' => 'earth',
      'phone' => '415.666.1234',
      'urls' => 'http://dot.com',
      'token' => '666_777_666'
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
      'urls' => 'http://dot.com',
      'token' => '666_777_666'
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
      'urls' => 'http://dot.com',
      'token' => '666_777_666'
      },
    'extra' => {
      'user_hash' => 'google magic'

    }
  }

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

end
