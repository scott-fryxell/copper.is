class InvalidTipURL < Exception ; end

class Tip < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  belongs_to :tip_order
  belongs_to :locator, :counter_cache => true
  has_one :site, :through => :locator
  has_one :tip_royalty

  validates_presence_of :tip_order
  validates_presence_of :locator
  validates_associated :locator
  validates_presence_of :amount_in_cents

  attr_accessible :amount_in_cents

  # minimum value per tip, in cents
  Tip::MINIMUM_TIP_VALUE = 1

  before_save do |tip|
    order = tip.tip_order
  end

  def tip_value
    amount_in_cents
  end
end
