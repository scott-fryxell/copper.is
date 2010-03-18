# == Schema Information
# Schema version: 20100309235816
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  number     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :orders
  
  attr_accessible :last_name, :first_name, :card_type, :number, :verification_value, :month, :year 
end
