module TwitterMessages
  def _send_wanted_message
    send_tweet ("A fan of yours has tipped you! The link explains it all. #{Copper::Application.config.hostname}/identities/#{self.id}/edit")
  end
end

module PhonyMessages
  def _send_wanted_message
    logger.info "#{self.inspect} URL=#{Copper::Application.config.hostname}/i/#{self.id}"
  end
end

module YoutubeMessages
  def _send_wanted_message
    comment("A fan of yours has tipped you! The link explains it all. #{Copper::Application.config.hostname}/identities/#{self.id}").post
  end
end

module FacebookMessages
  def _send_wanted_message
    logger.warn "there is no _send_wanted_message for Facebook"
  end
end
