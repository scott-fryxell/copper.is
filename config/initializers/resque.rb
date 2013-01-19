require 'resque/server'
Resque.redis = Copper::Application.config.redistogo_url

Resque::Server.use(Rack::Auth::Basic) do |user,password|
  password = Copper::Application.config.resque_overview_password
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }