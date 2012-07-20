module TwitterMessages
  def _send_wanted_message
    send_tweet ("A fan of your has tipped you! click the lind and we'll explain what hell is going on here. #{Copper::Application.config.hostname}/i/#{self.id} #{Time.now.to_i.to_s[6..-1]}")
  end
end

module PhonyMessages
  def _send_wanted_message
    logger.info "#{self.inspect} URL=#{Copper::Application.config.hostname}/i/#{self.id} "
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
