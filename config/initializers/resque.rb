require 'resque/server'
Resque.redis = ENV['REDISTOGO_URL'] if ENV['REDISTOGO_URL']
