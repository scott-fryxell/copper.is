class InvalidTipURL < Exception ; end

class Tip < ActiveRecord::Base
  belongs_to :page
  belongs_to :tip_order
  belongs_to :royalty_check
  has_one :user, :through => :tip_order

  default_scope :order => 'created_at DESC'

  attr_accessible :amount_in_cents
  
  scope :promised, where("paid_state = ?", 'promised')
  scope :charged, where("paid_state = ?", 'charged')
  scope :kinged, where("paid_state = ?", 'kinged').readonly

  MINIMUM_TIP_VALUE = 1
  MAXIMUM_TIP_VALUE = 2000
  validates :amount_in_cents,
    :numericality => { in:(MINIMUM_TIP_VALUE..MAXIMUM_TIP_VALUE) },
    :presence => true
   
  validates_associated :page

  validates :page, presence:true
  validates :tip_order, presence:true
  validates :amount_in_cents, presence:true
  
  state_machine :paid_state, :initial => :promised do
    event :pay do
      transition :promised => :charged
    end
    
    event :claim do
      transition :charged => :kinged
    end
    
    state :charged do
      validate :validate_presence_of_paid_tip_order
    end
  end
  
  def validate_presence_of_paid_tip_order
    unless self.tip_order.paid?
      errors.add(:tip_order_id, "tip order must be :paid for :charged tips")
    end
  end
end
