$cache = Memcache.new
Rails.application.config.middleware.use Rack::Cache, :metastore => $cache, :entitystore => 'file:tmp/cache/entity'
