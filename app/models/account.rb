
class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :orders
  
  attr_accessible :last_name, :first_name, :card_type, :number, :verification_value, :card_expires_on 
end
