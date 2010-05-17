class Tip < ActiveRecord::Base
  has_one :user
  has_one :resource
  has_one :order

  #TODO need validation, amount must be decimal

end
