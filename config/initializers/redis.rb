Redis.current.client.reconnect

uri =      URI.parse(Copper::Application.config.redistogo_url)
$eventer = Redis.new(host:uri.host, port:uri.port, password:uri.password)

heartbeat_thread = Thread.new do
  while true
    $eventer.publish "heartbeat","thump"
    sleep 3.seconds
  end
end

at_exit do
  # not sure this is needed, but just in case
  heartbeat_thread.kill
  $eventer.quit
end
