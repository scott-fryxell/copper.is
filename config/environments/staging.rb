Copper::Application.configure do
  config.force_ssl = true
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.assets.compress = true
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = true
  config.assets.debug = false
  config.assets.digest = true
  # config.action_controller.asset_host = "dxs9q85fcnuty.cloudfront.net"
  config.hostname = "https://copper-stage.herokuapp.com"
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=31536000"

  config.cache_store = :dalli_store
end
