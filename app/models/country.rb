class Country < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :abbreviation
end