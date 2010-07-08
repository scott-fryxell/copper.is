class Address < ActiveRecord::Base
  validates_presence_of :line_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :postal_code
  validates_presence_of :country

  validates_length_of :state, :is => 2
end
