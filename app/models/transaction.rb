class InvalidSplit < Exception ; end

class Transaction < ActiveRecord::Base
  # TODO - rename this model to Payment, so not confused with OrderTransaction
  belongs_to :account
  belongs_to :order
  has_one :user, :through => :account

  has_one :fee
  has_one :refill

  validates_presence_of :account
  validates_presence_of :order
  validates_presence_of :amount_in_cents
  validates_presence_of :fee, :on => :update
  validates_presence_of :refill, :on => :update

  validates_numericality_of :amount_in_cents, :only_integer => true, :greater_than => 0

  def valid_split?
    fee &&
    refill &&
    (amount_in_cents == fee.amount_in_cents + refill.amount_in_cents)
  end

  def split_refill_and_fee(percent = Configuration.find_by_property(Configuration::FEE_PERCENT).value)
    fee_percent = percent.is_a?(Integer) ? percent : percent.to_i
    if fee_percent == 0 || fee_percent >= 100
      return "the fee rate is incorrect"
    else
      split = calculate_split(fee_percent)
      self.fee = Fee.new(:amount_in_cents => split[:fee])
      self.refill = Refill.new(:amount_in_cents => split[:refill], :tip_bundle => user.active_tip_bundle)
      if valid_split?
        self.save
      else
        raise InvalidSplit
      end
    end
  end

  private

  def calculate_split(fee_percent)
    fee = (self.amount_in_cents * fee_percent) / 100
    refill = self.amount_in_cents - fee
    return {:fee => fee, :refill => refill}
  end

end
