class Tip < ActiveRecord::Base
  has_one :user
  has_one :order
  belongs_to :locator

  validates_presence_of :locator

end
