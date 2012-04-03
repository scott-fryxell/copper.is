class User < ActiveRecord::Base
  has_many :tips, :through => :tip_orders
  has_many :tip_orders, :foreign_key => "fan_id",:dependent => :destroy
  has_many :identities, :dependent => :destroy

  has_and_belongs_to_many :roles

  attr_accessible :name, :email, :tip_preference_in_cents

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by_name('Patron')
    end
  end

  def active_tips
    order = active_tip_order
    if order
      tips = Tip.find_all_by_tip_order_id(order.id, :order => "created_at DESC")
    else
      []
    end
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def rotate_tip_order!
    TipOrder.update(active_tip_order.id, :is_active => false)
    TipOrder.create(:fan => self)
  end

  def active_tip_order
    tip_orders.find(:first, :conditions => ["is_active = ?", true]) || TipOrder.new(:fan => self)
  end

  def tip(url_string, description = url_string)
    locator = Locator.find_or_init_by_url(url_string)
    amount_in_cents = self.tip_preference_in_cents

    if locator && amount_in_cents
      locator.page = Page.create(:description => description) unless locator.page

      tip = Tip.new(:amount_in_cents => amount_in_cents)
      tip.locator = locator
      tip.tip_order = active_tip_order
      if tip.valid?
        tip.save
        tip
      else
        nil
      end
    else
      nil
    end
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

  def active_tips_in_dollars
    cents_to_dollars(self.active_tip_order.tips.sum(:amount_in_cents))
  end


  private

end
