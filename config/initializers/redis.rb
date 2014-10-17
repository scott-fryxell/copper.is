uri = URI.parse(Copper::Application.config.redistogo_url)
$eventer = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
