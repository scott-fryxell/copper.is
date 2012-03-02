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
      'name' => 'twitter_fan',
      'email' => 'user@twitter.com',
    },
    'extra' => {
      'user_hash' => 'twitter magic'
    }

  }
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '234567',
    'info' => {
      'name' => 'facebook_fan',
      'email' => 'user@facebook.com',
    },
    'extra' => {
      'user_hash' => 'facebook magic'
    }

  }
  OmniAuth.config.mock_auth[:google] = {
    'provider' => 'google',
    'uid' => '234567',
    'info' => {
      'name' => 'google_fan',
      'email' => 'user@google.com',
      },
    'extra' => {
      'user_hash' => 'google magic'

    }
  }

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

end
