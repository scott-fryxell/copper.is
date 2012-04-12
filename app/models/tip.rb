class InvalidTipURL < Exception ; end

class Tip < ActiveRecord::Base
  belongs_to :page
  belongs_to :tip_order
  belongs_to :royalty_check
  has_one :user, :through => :tip_order

  default_scope :order => 'created_at DESC'

  attr_accessible :amount_in_cents
  scope :promised, where("state = ?", 'promised')
  scope :charged, where("state = ?", 'charged')
  scope :received, where("state = ?", 'received')

  MINIMUM_TIP_VALUE = 1
  MAXIMUM_TIP_VALUE = 2000
  validates :amount_in_cents,
    :numericality => { in:(MINIMUM_TIP_VALUE..MAXIMUM_TIP_VALUE) },
    :presence => true

  validates :page, presence:true
  validates :tip_order, presence:true
  validates :amount_in_cents, presence:true
end
