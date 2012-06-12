module Channels
  class Email < Channel
    # this doesn't match gmail '+' tags
    RE = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
    validates :address, format:{with:RE}, :allow_nil => true
  end
end
