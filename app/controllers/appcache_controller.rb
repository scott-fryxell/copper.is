class AppcacheController < ApplicationController

  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    response.stream.write(sse({page: Page.first}, {event: 'page'}))

  rescue IOError
    # Client Disconnected
    logger.info "stream closed #{current_user.name}"
  ensure
    response.stream.close
  end

private

  def sse(object, options = {})
    (options.map{|k,v| "#{k}: #{v}" } << "data: #{JSON.dump object}").join("\n") + "\n\n"
  end

end
