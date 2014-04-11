Copper::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.assets.compress = false
  config.assets.debug = true
  config.assets.compile = true
  config.assets.digest = false

  config.hostname = "http://copper.dev"
  config.facebook_appname = "copper-dev"
  config.facebook_appid = "180829622036113"

  config.log_level = :info
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.25
  config.lograge.enabled = true

end
