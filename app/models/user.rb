class User < ActiveRecord::Base

  has_many :tips, :through => :tip_orders
  has_many :tip_orders, :foreign_key => "fan_id"

  has_and_belongs_to_many :roles

  attr_accessible :name

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
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
    tip_orders.find(:first, :conditions => ["is_active = ?", true]) || TipBundle.new(:fan => self)
  end

  def tip(url_string, description = 'new page')
    locator = Locator.find_or_init_by_url(url_string)
    amount_in_cents = self.tip_preference_in_cents

    if locator && amount_in_cents
      locator.page = Page.create(:description => description) unless locator.page

      tip = Tip.new(:locator         => locator,
                    :tip_order      => active_tip_order,
                    :amount_in_cents => amount_in_cents
                    )
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

  private

end
