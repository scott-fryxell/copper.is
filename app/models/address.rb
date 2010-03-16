# == Schema Information
# Schema version: 20100309235816
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
#

class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  
end
