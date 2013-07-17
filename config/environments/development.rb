Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress = false
  config.assets.debug = true
  config.hostname = "http://copper.dev"
  config.facebook_appname = "copper-dev"
  config.facebook_appid = "180829622036113"
  config.honeybadger_js_app_id = "df5151fb675d4d4af78d117fab648540"
  config.log_level = :info
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.25
  config.lograge.enabled = true
  # OmniAuth.config.test_mode = true
  # OmniAuth.config.mock_auth[:facebook] = {
  #   'provider' => 'facebook',
  #   'uid' => '234567',
  #   'info' => {
  #     'name' => 'facebook user',
  #     'nickname'=> 'facebook.user',
  #     'email' => 'user@facebook.com'
  #   },
  #   'credentials' => {
  #     'token' => '666_777_666',
  #     'secret' => 'its_a_secret'
  #   },
  # }

end
