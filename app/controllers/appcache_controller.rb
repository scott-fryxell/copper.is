class AppcacheController < ApplicationController

  include ActionController::Live

   def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = Reloader::SSE.new(response.stream)
    puts 'server events started'

    begin
      directories = [
        File.join(Rails.root, 'app', 'assets'),
        File.join(Rails.root, 'app', 'views'),
      ]
      fsevent = FSEvent.new
      # Watch the above directories
      fsevent.watch(directories) do |dirs|
        puts 'file changed'
        # Send a message on the "refresh" channel on every update
        sse.write({ :dirs => dirs }, event:'refresh_cache')
      end
      fsevent.run

    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end

end
