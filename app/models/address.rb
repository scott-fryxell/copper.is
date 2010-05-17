class Address < ActiveRecord::Base
  has_one :account
  
end
