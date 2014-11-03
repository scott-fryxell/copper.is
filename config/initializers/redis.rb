heartbeat_thread = Thread.new do
  while true
    $eventer.publish "heartbeat","thump"
    sleep 3.seconds
  end
end

at_exit do
  # not sure this is needed, but just in case
  heartbeat_thread.kill
end
