require 'resque/server'
Resque::Server.use(Rack::Auth::Basic) do |user,password|
  password = Copper::Application.config.resque_overview_password
end

Resque.redis = Copper::Application.config.redistogo_url

Resque.after_fork = Proc.new {
  puts "***************** After fork resque ******************************º"
  # ActiveRecord::Base.establish_connection
  # uri = URI.parse(Copper::Application.config.redistogo_url)
  Resque.redis = Redis.new(host:uri.host, port:uri.port, password:uri.password)
  #
  # Resque.redis.reconnect
}
