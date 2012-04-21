class RoyaltyCheck < ActiveRecord::Base
  belongs_to :user
  has_many :tips

  # validates :user, presence:true
  
  scope :earned, where("check_state = ?", 'earned')
  scope :paid, where("check_state = ?", 'paid')  
  scope :cashed, where("check_state = ?", 'cashed')
  
  state_machine :check_state, :initial => :earned do
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
