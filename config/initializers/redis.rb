put "*************************"
put Copper::Application.config.redistogo_url
put "************************"
uri = URI.parse(Copper::Application.config.redistogo_url)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)