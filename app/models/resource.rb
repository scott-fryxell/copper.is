class Resource < ActiveRecord::Base
  
  has_many :users, :through => :tips
  belongs_to :user
  has_many :tips
  
end
