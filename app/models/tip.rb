class Tip < ActiveRecord::Base
  belongs_to :tip_bundle
  belongs_to :locator

  validates_presence_of :tip_bundle
  validates_presence_of :locator

  validates_numericality_of :multiplier, :only_integer => true, :greater_than => 0
end
