class TipRate < ActiveRecord::Base
  validates_presence_of :amount_in_cents
  validates_uniqueness_of :amount_in_cents
  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0

  has_many :users
end