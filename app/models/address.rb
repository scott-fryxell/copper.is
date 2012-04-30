class Address < ActiveRecord::Base
  belongs_to :user
  attr_accessible :city, :country, :line1, :line2, :postal_code, :state, :territory
  validates_presence_of :line_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :postal_code
  validates_presence_of :country
  validates_length_of :state, :is => 2
end
