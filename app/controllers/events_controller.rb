class EventsController < ApplicationController

  include ActionController::Live

  def domain
  end

  def collection
  end

  def member
    response.headers['Content-Type'] = 'text/event-stream'

    redis = Redis.new
    redis.psubscribe('pages.*') do |on|
      on.pmessage do |pattern, event, data|

        logger.info event
        logger.info pattern
        logger.info data

        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end

  rescue IOError
    # Client Disconnected
    logger.info "client.Disconected #{current_user.name if current_user}"
  ensure
    redis.quit
    response.stream.close
  end

end
