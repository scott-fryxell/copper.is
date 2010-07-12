class Fee < ActiveRecord::Base
  belongs_to :transaction

  validates_presence_of :transaction
  validates_presence_of :amount_in_cents

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0
end
