class EventsController < ApplicationController

  include ActionController::Live

  def publisher
    response.headers['Content-Type'] = 'text/event-stream'

    publisher = Redis.new
    publisher.psubscribe('page.save') do |on|
      on.pmessage do |pattern, event, data|
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end

  rescue IOError
    # Client Disconnected
    logger.info "client.Disconected #{current_user.name if current_user}"
  ensure
    puts "ensure redis closed"
    publisher.quit
    response.stream.close
  end

end
