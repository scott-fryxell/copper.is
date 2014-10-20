Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    if Rails.application.config.database_configuration
      config = Rails.application.config.database_configuration[Rails.env]
      config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 5 # seconds
      config['pool']              = ENV['DB_POOL']      || 16
      ActiveRecord::Base.establish_connection(config)
    end
  end

  if defined?(Resque)
    # uri = URI.parse(Copper::Application.config.redistogo_url)
    # Resque.redis = Redis.new(host:uri.host, port:uri.port, password:uri.password)

    Redis.current.client.reconnect
    $eventer = Redis.current

  end
end
