class User < ActiveRecord::Base
  acts_as_authentic

  has_one :address
  has_many :accounts

  has_many :transactions, :through => :accounts
  has_many :tips, :through => :tip_bundles
  has_many :tip_bundles, :foreign_key => "fan_id"

  has_and_belongs_to_many :roles

  #AuthLogic validate the uniqueness of the email field by convention
  #validates_uniqueness_of :email

  attr_accessible :email, :password, :password_confirmation

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def activate!
    self.active = true
    self.activation_date = Time.now
    save
  end

  def deliver_user_activation!
    reset_perishable_token!
    Notifier.deliver_user_activation(self)
  end

  def deliver_user_welcome!
    reset_perishable_token!
    Notifier.deliver_user_welcome(self)
  end

  def deliver_password_reset!
    reset_perishable_token!
    Notifier.deliver_password_reset(self)
  end

  def self.find_active_users
    find(:all, :conditions => "active = 't'", :order => "created_at DESC")
  end

  def rotate_tip_bundle!
    TipBundle.update(active_tip_bundle.id, :is_active => false)
    TipBundle.create(:fan => self)
  end

  def active_tip_bundle
    tip_bundles.find(:first, :conditions => ["is_active = ?", true])
  end

  def tip(url_string, description = 'new page', multiplier = 1)
    raise TipBundleMissing unless active_tip_bundle != nil

    locator = Locator.parse(url_string)
    locator.page = Page.create(:description => description)

    Tip.create(:locator    => locator,
               :tip_bundle => active_tip_bundle,
               :multiplier => multiplier)
  end
end
