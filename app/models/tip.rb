class CantDestroyException < Exception ; end
class Tip < ActiveRecord::Base
  belongs_to :page
  belongs_to :order
  belongs_to :check
  has_one :fan, :through => :order
  has_one :author, :through => :page
  has_paper_trail

  scope :promised, where("tip_state = ?", 'promised')
  scope :charged, where("tip_state = ?", 'charged')
  scope :taken, where("tip_state = ?", 'taken').readonly
  default_scope :order => 'created_at DESC'

  validates :order, presence:true
  validates :amount_in_cents, presence:true
  validate :validate_only_being_added_to_current_order, :on => :create
  def validate_only_being_added_to_current_order
    if order
      unless self.order.current?
        errors.add(:order_id,"can only add a tip to a current order")
      end
    end
  end

  after_create do |tip|
    Resque.enqueue Page::SpiderJob, tip.url
  end

  before_destroy do |tip|
    raise CantDestroyException unless tip.promised?
  end

  MINIMUM_TIP_VALUE = 1
  MAXIMUM_TIP_VALUE = 2000
  validates :amount_in_cents,
    :numericality => { in:(MINIMUM_TIP_VALUE..MAXIMUM_TIP_VALUE) },
    :presence => true


  state_machine :tip_state, :initial => :promised do
    event :pay do
      transition :promised => :charged
    end

    event :claim do
      transition :charged => :kinged
    end

    state :charged, :taken do
      validate :validate_presence_of_paid_order
    end

    state :taken do
      validate :validate_presence_of_check
    end
  end

end
