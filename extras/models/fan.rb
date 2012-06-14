class Fan < ActiveRecord::Base
  has_many :orders
  
  validates :tip_preference_in_cents,
  :numericality => { greater_than_or_equal_to:Tip::MINIMUM_TIP_VALUE },
  :presence => true
  validates :name, length:{in:3..128}, allow_nil:true

  
  def current_order
    orders.current.first or self.orders.create!
  end

  def create_stripe_customer (card_token)
    if self.stripe_customer_id
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
    else
      customer = Stripe::Customer.create(
                                         :description => self.email,
                                         :card => card_token
                                         )
      self.stripe_customer_id = customer.id
    end
    return customer;
  end

  def delete_stripe_customer
    if self.stripe_customer_id
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.delete
    end
  end
end
