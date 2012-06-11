class InvalidTipURL < Exception ; end
class CantDestroyException < Exception ; end

class Tip < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  
  belongs_to :page
  belongs_to :order
  belongs_to :check
  has_one :fan, :through => :order
  has_one :author, :through => :page
  has_one :site, :through => :page

  attr_accessor :url,:title

  attr_accessible :amount_in_cents,:url,:title

  scope :promised, where("paid_state = ?", 'promised')
  scope :charged, where("paid_state = ?", 'charged')
  scope :kinged, where("paid_state = ?", 'kinged').readonly
  default_scope :order => 'created_at DESC'

  MINIMUM_TIP_VALUE = 1
  MAXIMUM_TIP_VALUE = 2000
  validates :amount_in_cents,
    :numericality => { in:(MINIMUM_TIP_VALUE..MAXIMUM_TIP_VALUE) },
    :presence => true

  validates :order, presence:true
  validates :amount_in_cents, presence:true
  validate :validate_only_being_added_to_current_order, :on => :create
  def validate_only_being_added_to_current_order
    unless self.order.current?
      errors.add(:order_id,"can only add a tip to a current order")
    end
  end
  
  after_create do |tip|
    Resque.enqueue Tip, tip.id, :find_or_create_page!
  end

  before_destroy do |tip|
    raise CantDestroyException unless tip.promised?
  end

  state_machine :paid_state, :initial => :promised do
    event :pay do
      transition :promised => :charged
    end

    event :claim do
      transition :charged => :kinged
    end

    state :charged, :kinged do
      validate :validate_presence_of_paid_order
    end

    state :kinged do
      validate :validate_presence_of_check
    end
  end

  def validate_presence_of_paid_order
    unless self.order.paid?
      errors.add(:order_id, "tip order must be :paid for :charged tips")
    end
  end

  def validate_presence_of_check
    unless self.check_id
      errors.add(:check_id, "check_id must not be null for :kinged tips")
    end
  end

  def url
    page.url
  end

  def title
    page.title
  end
end
