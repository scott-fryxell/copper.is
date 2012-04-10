class RoyaltyCheck < ActiveRecord::Base
  belongs_to :user
  has_manuy :tips

  def total_amount_in_cents
    royalties.sum('amount_in_cents')
  end
end
