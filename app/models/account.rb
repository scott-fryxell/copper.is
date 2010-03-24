
class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :orders
  
  attr_accessible :card_type, :last_name, :first_name, :number, :verification_value, :card_expires_on 
end
