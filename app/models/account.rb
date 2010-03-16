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
  
  attr_accessible :number
end
