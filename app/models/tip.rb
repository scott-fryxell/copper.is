class InvalidTipURL < Exception ; end
class CantDestroyException < Exception ; end
class Tip < ActiveRecord::Base

  belongs_to :page, touch:true
  belongs_to :order, touch:true
  belongs_to :check
  has_one    :user, :through => :order #, :as => :fan

  include Enqueueable
  include Historicle
  include State::Payable

  default_scope  { order('created_at DESC') }

  MINIMUM_TIP_VALUE = 1
  MAXIMUM_TIP_VALUE = 2000

  validates :amount_in_cents,
    :numericality => { in:(MINIMUM_TIP_VALUE..MAXIMUM_TIP_VALUE) },
    :presence => true

  validates_associated :page

  validates :page, presence:true
  validates :amount_in_cents, presence:true

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
