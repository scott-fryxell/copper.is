require 'resque/server'

workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.connection_pool.disconnect!
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 16
    ActiveRecord::Base.establish_connection(config)
  end

  if defined?(Resque)
    # uri = URI.parse(Copper::Application.config.redistogo_url)
    # Resque.redis = Redis.new(host:uri.host, port:uri.port, password:uri.password)

    Redis.current.client.reconnect
    $eventer = Redis.current

  end
end
