DirtyWhiteCouch::Application.configure do
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
    'user_info' => {
      'name' => 'twitter_fan'
    }
  }
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '234567',
    'user_info' => {
      'name' => 'facebook_fan'
    }
  }
  OmniAuth.config.mock_auth[:google] = {
    'provider' => 'google',
    'uid' => '234567',
    'user_info' => {
      'name' => 'google_fan'
    }
  }
end
