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
  
  @queue = :high
  def self.perform(page_id, message, args=[])
    find(page_id).send(message, *args)
  end

  # def total_amount_in_cents
  #   royalties.sum('amount_in_cents')
  # end
  
  def message_author!
    puts "======================================================"
    puts "RoyaltyCheck.count == #{self.count}"
    if self.count == 0
      puts "======================================================"
      puts "RoyaltyCheck.count == #{self.count}"
      self.user.message_about_royalty_check(self.id)
      self.count = self.count + 1
      save!
      puts "RoyaltyCheck.count (After) == #{self.count}"
    end
  end
end
