class Transaction < ActiveRecord::Base
  belongs_to :account

  validates_presence_of :account
  validates_presence_of :amount_in_cents

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0
end
