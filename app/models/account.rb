class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :billing_address, :class_name => "Address", :foreign_key => "billing_address_id"
  belongs_to :card_type
  has_many :orders

  validates_presence_of :user
  validates_presence_of :billing_address
  validates_presence_of :billing_name
  validates_presence_of :number
  validates_presence_of :expires_on
  validates_presence_of :card_type
end
