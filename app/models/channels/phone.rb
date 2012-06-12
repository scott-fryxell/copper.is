module Channels
  class Phone < Channel
    # this doesn't match gmail '+' tags
    RE = /^[0-9]{10}$/
    # validates :address, format:{with:RE}, :allow_nil => true
    
    before_save do |phone|
      phone.address = phone.address.gsub(/[^0-9]/,'')
    end
  end
end
