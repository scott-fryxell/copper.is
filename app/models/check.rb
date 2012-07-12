class Check < ActiveRecord::Base

  belongs_to :author
  has_many :tips
  has_paper_trail

  validates :author, presence:true

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

    state :earned do
    end
  end

end
