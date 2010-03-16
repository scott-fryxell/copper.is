# == Schema Information
# Schema version: 20100309235816
#
# Table name: tips
#
#  id         :integer         not null, primary key
#  url        :text
#  amount     :decimal(, )
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tip < ActiveRecord::Base
  has_one :user
  has_one :resource
  has_one :order
end
