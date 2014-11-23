class InvalidTipURL < Exception ; end
class CantDestroyException < Exception ; end
class Tip < ActiveRecord::Base

  belongs_to :page, touch:true
  belongs_to :order, touch:true
  belongs_to :check
  has_one :user, :through => :order #TODO: as:'fan'


  include Enqueueable
  include Historicle
  include Artist::Payable

  default_scope  { order('created_at DESC') }

  attr_accessor :url,:title

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

  before_destroy do |tip|
    tip.page.touch
    raise CantDestroyException unless tip.promised?
  end


  def validate_only_being_added_to_current_order
    unless self.order.current?
      errors.add(:order_id,"can only add a tip to a current order")
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

  def amount_in_dollars
    amount = Float(self.amount_in_cents) / 100
    sprintf('%.2f', amount)
  end

  def thumbnail
    page.thumbnail_url
  end

  def url
    URI page.url
  end

  def title
    page.title
  end
end
