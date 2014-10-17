uri = URI.parse(Copper::Application.config.redistogo_url)
Resque.redis = Redis.new(host:uri.host, port:uri.port, password:uri.password)
$eventer = Redis.current
