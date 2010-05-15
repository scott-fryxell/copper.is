# == Schema Information
# Schema version: 20100324194135
#
# Table name: addresses
#
#  id         :integer         not null, primary key
#  street1    :string(255)
#  street2    :string(255)
#  city       :string(255)
#  zip        :string(255)
#  country    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class Address < ActiveRecord::Base
  has_one :account
  
end
