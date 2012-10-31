class InvalidTipURL < Exception ; end
class CantDestroyException < Exception ; end
class Tip < ActiveRecord::Base
  belongs_to :page, :counter_cache => true
  belongs_to :order
  belongs_to :check
  has_one :user, :through => :order
  has_paper_trail
  default_scope :order => 'created_at DESC'

  attr_accessor :url,:title,:thumbnail_url

  attr_accessible :amount_in_cents,:url,:title,:thumbnail_url
  scope :trending, order("Date(updated_at)")
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
  validates :order, presence:true
  validates :amount_in_cents, presence:true
  validate :validate_only_being_added_to_current_order, :on => :create
  def validate_only_being_added_to_current_order
    unless self.order.current?
      errors.add(:order_id,"can only add a tip to a current order")
    end
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

  def thumbnail_url
    page.thumbnail_url
  end

  def url
    URI page.url
  end

  def title
    page.title
  end
end
