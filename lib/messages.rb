module TwitterMessages
  def _send_wanted_message
    send_tweet ("A fan of yours has tipped you! click the link and we'll explain what the hell is going on here. #{Copper::Application.config.hostname}/identities/#{self.id}")
  end
end

module PhonyMessages
  def _send_wanted_message
    logger.info "#{self.inspect} URL=#{Copper::Application.config.hostname}/i/#{self.id}"
  end
end

module YoutubeMessages
  def _send_wanted_message
    comment("A fan of yours has tipped you! click the link and we'll explain what the hell is going on here. #{Copper::Application.config.hostname}/identities/#{self.id}").post
  end
end

module FacebookMessages
  def _send_wanted_message
    logger.warn "there is no _send_wanted_message for Facebook"
  end
end
