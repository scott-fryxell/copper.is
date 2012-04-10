class InvalidTipURL < Exception ; end

class Tip < ActiveRecord::Base
  belongs_to :page
  belongs_to :tip_order
  belongs_to :royalty_check
  has_one :user, :through => :tip_order

  default_scope :order => 'created_at DESC'

  attr_accessible :amount_in_cents

  MINIMUM_TIP_VALUE = 1
  validates_numericality_of :amount_in_cents, greater_than_or_equal_to:MINIMUM_TIP_VALUE

end
