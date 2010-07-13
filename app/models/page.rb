class Page < ActiveRecord::Base
  has_many :locators

  validates_presence_of :description
end
