class Channel < ActiveRecord::Base
  attr_accessible :address
  
  before_create do |channel|
    if channel.type.blank?
      if channel.address =~ Channels::Email::RE
        channel.type = 'Channels::Email'
      elsif channel.could_be_a_phone_number?
        channel.type = 'Channels::Phone'
      end
    end
  end
  
  def could_be_a_phone_number?
    address.gsub(/[^0-9]/,'') =~ Channels::Phone::RE
  end
end
