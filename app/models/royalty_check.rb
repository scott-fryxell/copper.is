class RoyaltyCheck < ActiveRecord::Base
  belongs_to :user
  has_many :tips

  validates :user, presence:true
  
  scope :earned, where("state = ?", 'earned')
  scope :paid, where("state = ?", 'paid')  
  scope :cashed, where("state = ?", 'cashed')
  
  state_machine :state, :initial => :earned do
    event :deliver do
      transition :earned => :paid
    end
    event :reconcile do
      transition :paid => :cashed
    end
  end
  
  def total_amount_in_cents
    royalties.sum('amount_in_cents')
  end
end
