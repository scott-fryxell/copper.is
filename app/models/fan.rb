class Fan < ActiveRecord::Base

  has_many :orders
  has_many :tips, :through => :orders
  has_and_belongs_to_many :roles
  belongs_to :author
  has_paper_trail

  validates :tip_preference_in_cents,
    :numericality => { greater_than_or_equal_to:Tip::MINIMUM_TIP_VALUE },
    :presence => true

  validates :name, length:{in:3..128}, allow_nil:true

  validate :validate_one_current_order, on:'save'
  def validate_one_current_order
    errors.add(:orders, "there must be only one") unless self.orders.current.size == 1
  end

  after_create :create_current_order!
  def create_current_order!
    if self.orders.unpaid.count > 0
      raise "there is already an unpaid Order for this user: #{self.inspect}"
    end
    self.orders.create!
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by_name('Fan')
    end
  end

  def tip!(amount_in_cents, url, title = nil)
    current_order.tips.create!(url:url,amount_in_cents:amount_in_cents,title:title)
  end

  def current_order
    orders.current.first or orders.create!
  end

  def charge_info?
    !!self.stripe_id
  end

  def current_order
    self.orders.current.first or self.orders.create
  end

  def current_tips
    current_order.tips
  end

  def create_stripe_customer (card_token)
    if self.stripe_id
      customer = Stripe::Customer.retrieve(self.stripe_id)
    else
      customer = Stripe::Customer.create(
        :description => self.email,
        :card => card_token
      )
      self.stripe_id = customer.id
    end
    return customer;
  end

  def delete_stripe_customer
    if self.stripe_id
      customer = Stripe::Customer.retrieve(self.stripe_id)
      customer.delete
    end
  end


end
