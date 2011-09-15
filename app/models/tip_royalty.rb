class TipRoyalty < ActiveRecord::Base
  belongs_to :royalty_order
  belongs_to :tip

  validates_presence_of :royalty_order
  validates_presence_of :tip

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0

  def valid_tip_value?
    self.amount_in_cents == tip.amount_in_cents
  end
end
