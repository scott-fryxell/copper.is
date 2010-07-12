class Transaction < ActiveRecord::Base
  belongs_to :account

  has_one :fee
  has_one :refill

  validates_presence_of :account
  validates_presence_of :amount_in_cents
  validates_presence_of :fee, :on => :update
  validates_presence_of :refill, :on => :update

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0

  def valid_split?
    fee &&
    refill &&
    (amount_in_cents == fee.amount_in_cents + refill.amount_in_cents)
  end
end
