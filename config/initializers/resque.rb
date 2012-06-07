require 'resque/server'
Resque.redis = Copper::Application.config.redistogo_url
