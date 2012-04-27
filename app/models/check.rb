class Check < ActiveRecord::Base
  include Enqueueable
  
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
  
  def message_author!
    if self.count == 0
      self.user.message_about_check(self.id)
      self.count = self.count + 1
      save!
    end
  end
end
