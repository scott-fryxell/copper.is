class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  has_many :orders
  
  accepts_nested_attributes_for :address, :allow_destroy => true
  
  attr_accessible :card_type, :last_name, :first_name, :number, :verification_value, :card_expires_on, :address_attributes
end
