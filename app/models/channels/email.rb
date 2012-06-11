module Channels
  class Email < Channel
    # this doesn't match gmail '+' tags
    EMAIL_RE = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
    validates :address, format:{with:EMAIL_RE}, :allow_nil => true
  end
end
