class RoyaltyCheck < ActiveRecord::Base
  belongs_to :user
  has_many :tips

  validates :user, presence:true
  
  scope :earned, where("state = ?", 'earned')
  scope :paid, where("state = ?", 'paid')  
  scope :cashed, where("state = ?", 'cashed')
  
  def total_amount_in_cents
    royalties.sum('amount_in_cents')
  end
end
