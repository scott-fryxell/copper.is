class Refill < ActiveRecord::Base
  belongs_to :tip_bundle
  belongs_to :transaction

  validates_presence_of :tip_bundle
  validates_presence_of :transaction
  validates_presence_of :amount_in_cents

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0
end
