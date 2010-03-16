# == Schema Information
# Schema version: 20100309235816
#
# Table name: resources
#
#  id         :integer         not null, primary key
#  scheme     :string(255)
#  userinfo   :string(255)
#  host       :string(255)
#  port       :integer
#  registry   :string(255)
#  path       :string(255)
#  opaque     :string(255)
#  query      :string(255)
#  fragment   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Resource < ActiveRecord::Base
  
  has_many :users, :through => :tips
  # has_one  :publisher
end
