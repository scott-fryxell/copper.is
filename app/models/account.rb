# == Schema Information
# Schema version: 20100324194135
#
# Table name: accounts
#
#  id                 :integer         not null, primary key
#  number             :integer
#  created_at         :datetime
#  updated_at         :datetime
#  card_type          :string(255)
#  verification_value :integer
#  first_name         :string(255)
#  last_name          :string(255)
#  card_expires_on    :date
#  user_id            :integer
#  address_id         :integer
#


class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  has_many :orders
  
  accepts_nested_attributes_for :address, :allow_destroy => true
  
  attr_accessible :card_type, :last_name, :first_name, :number, :verification_value, :card_expires_on, :address_attributes
end
