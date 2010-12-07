class InvalidTipURL < Exception ; end

class Tip < ActiveRecord::Base
  belongs_to :tip_bundle
  belongs_to :locator, :counter_cache => true
  has_one :site, :through => :locator
  has_one :tip_royalty

  validates_presence_of :tip_bundle
  validates_presence_of :locator
  validates_associated :locator
  validates_presence_of :amount_in_cents

  # validates_numericality_of :multiplier, :only_integer => true, :greater_than => 0

  # minimum value per tip, in cents
  Tip::MINIMUM_TIP_VALUE = 1

  before_save do |tip|
    bundle = tip.tip_bundle
  end

  # def amount_in_cents
  #   tip_bundle.cents_per_tip_point * multiplier
  # end

  def tip_value
    amount_in_cents
  end
end
