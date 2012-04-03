require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |user,password|
  password = Copper::Application.config.resque_overview_password
end
