module TwitterMessages
  def send_wanted_message
    send_tweet ("A fan of yours has tipped you! The link explains it all. #{Copper::Application.config.hostname}/authors/#{self.id}/edit")
  end
end

module PhonyMessages
  def send_wanted_message
    # puts "#{self.inspect} URL=#{Copper::Application.config.hostname}/i/#{self.id}"
  end
end

module YoutubeMessages
  def send_wanted_message
    # comment("A fan of yours has tipped you! The link explains it all. #{Copper::Application.config.hostname}/authors/#{self.id}").post
  end
end

module FacebookMessages
  def _send_wanted_message
    # logger.warn "there is no _send_wanted_message for Facebook"
  end
end

module OrderMessages
  def send_paid_order_message card_number
    m = Mandrill::API.new(Copper::Application.config.mandrill_key)
    m.messages 'send-template', {
      template_name: "order reciept",
      template_content: [
        { name: "order_id",
          content: "#{self.id}"
        },
        { name: "order_total",
          content: "$#{self.total_in_dollars}"
        },
        { name: "order_date",
          content: "#{self.updated_at.strftime('%m/%d/%Y')}"
        },
        { name: "order_credit_card_number",
          content: "#{card_number}"
        },
        { name: "order_subtotal",
          content: "$#{self.subtotal_in_dollars}"
        },
        { name: "order_fee",
          content: "$#{self.fees_in_dollars}"
        },
        { name: "order_tips",
          content: self.tips_to_table_rows
        }
      ],
      message: {
        subject:"Your Receipt for order number #{self.id}",
        from_email: "us@copper.is",
        from_name: "The Copper Team",
        to:[{email:self.user.email, name:self.user.name}]
      }
    }
  end

  def send_card_expired_message

  end
end

module UserMessages

  def send_fan_welcome_message 
    m = Mandrill::API.new(Copper::Application.config.mandrill_key)
    m.messages 'send-template', {
      template_name: "welcome-message-for-fans",
      template_content: [],
      message: {
        subject:"Welcome to copper!",
        from_email: "us@copper.is",
        from_name: "The Copper Team",
        to:[{email:self.email, name:self.name}]
      }
    }
  end

  def send_message_to_fans_who_have_tipped
    User.have_tipped
    
    m = Mandrill::API.new(Copper::Application.config.mandrill_key)
    m.messages 'send-template', {
      template_name: "fans who have tipped",
      template_content: [],
      message: {
        subject:"Take a look at what you've tipped!",
        from_email: "us@copper.is",
        from_name: "The Copper Team",
        to:[{email:self.email, name:self.name}]
      }
    }
  end

  def send_message_fans_who_are_signed_up_with_payment_info_no_tips_yet
    User.no_tips_yet
    User.payment_info
  end
end

module AuthorMessage 

end
