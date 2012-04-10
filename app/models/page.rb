class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips
  attr_accessible :title
end
