class User < ActiveRecord::Base
  has_many :identities
  has_many :tip_orders
  has_many :tips, :through => :tip_orders
  has_many :royalty_checks
  has_and_belongs_to_many :roles

  attr_accessible :name, :email, :tip_preference_in_cents
  
  validates :tip_preference_in_cents,
    :numericality => { greater_than_or_equal_to:Tip::MINIMUM_TIP_VALUE },
    :presence => true
  validates :name, length:{in:3..128}
    
  # this doesn't match gmail '+' tags
  EMAIL_RE = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  validates :email, format:{with:EMAIL_RE}, :allow_nil => true

  # validate :validate_one_current_tip_order

  # def validate_one_current_tip_order
  #  errors.add(:tip_orders, "there can be only one") unless self.tip_orders.current.size == 1
  # end
  
  after_create :create_current_tip_order
  
  def create_current_tip_order
    tip_orders.create
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by_name('Patron')
    end
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def tip(args = {})
    url    = args[:url]
    title  = args[:title]  || url
    amount_in_cents = args[:amount_in_cents] || self.tip_preference_in_cents
    
    tip = Tip.new(:amount_in_cents => amount_in_cents)
    tip.page = Page.normalized_find_or_create(url,title)
    tip.tip_order = self.tip_orders.current.first
    tip.save
    tip
  end

  def charge_info?
    !!self.stripe_customer_id
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

  def current_tip_order
    tip_orders.current.first
  end
  
  def current_tips
    current_tip_order.tips
  end
  
  # def active_tips_in_dollars
  #   cents_to_dollars(self.current_tip_order.tips.sum(:amount_in_cents))
  # end
end
