class Channel < ActiveRecord::Base
  include STIFactory
  
  attr_accessible :address, :type
end
