module Channels
  class Email < Channel

    #TODO this doesn't match gmail '+' tags
    EMAIL_RE = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
    validates :address, format:{with:EMAIL_RE}, :allow_nil => true

    def you_have_tips_waiting(message_id)
    end
  end
end
