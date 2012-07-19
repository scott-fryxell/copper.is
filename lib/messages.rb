module TwitterMessages
  def _send_wanted_message
    send_tweet ("Someone loves you.  http://127.0.0.1:5000/i/#{self.id} #{Time.now.to_i.to_s[6..-1]}")
  end
end

module YoutubeMessages
  def _send_wanted_message
    comment('foobar').post
  end
end

module FacebookMessages
  def _send_wanted_message
    logger.warn "there is no _send_wanted_message for Facebook"
  end
end
