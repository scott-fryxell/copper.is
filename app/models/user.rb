class User < ActiveRecord::Base
  acts_as_authentic

  has_one :address
  has_many :accounts

  has_many :transactions, :through => :accounts
  has_many :tips, :through => :tip_bundles
  has_many :tip_bundles, :foreign_key => "fan_id"

  has_and_belongs_to_many :roles

  belongs_to :tip_rate

  #AuthLogic validate the uniqueness of the email field by convention
  #validates_uniqueness_of :email

  #todo figure out how to support this and our email
  #validates_uniqueness_of :facebook_uid

  attr_accessible :email, :password, :password_confirmation

  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.roles << Role.find_by_name("Patron")
    self.active = true
    self.activation_date = Time.now
  end

  def active_tips
    bundle = active_tip_bundle
    if bundle
      tips = Tip.find_all_by_tip_bundle_id(bundle.id, :order => "created_at DESC")
    else
      []
    end
  end

  def funds_for_tipping?
    if (active_tip_bundle.cents_per_tip_point > Tip::MINIMUM_TIP_VALUE) ||
      (active_tip_bundle.allocated_funds > 0 && active_tip_bundle.tip_points == 0)
      true
    else
      false
    end
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def new_email_submit(new_email)
    current_email = self.email # hold on to the existing email
    self.email = new_email
    if self.valid?
      self.email = current_email # set the email back to the current email
      self.new_email = new_email # put the new email in the new_email field
      if save
        self.deliver_email_change_notify! # send notifcation to existing address
        self.deliver_email_change_confirm! # send confirmation email to new address
      else
        false
      end
    end
  end

  def new_email_confirmed!
    unless self[:new_email].blank?
      email = self[:email]
      self[:email] = self[:new_email]
      if self.valid?
        self[:new_email] = nil
        self[:new_email_token] = nil
        save
      else
        self[:email] = email
        self.new_email_token = nil
        return false
      end
    else
      false
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

  def deliver_email_change_notify!
    Notifier.deliver_email_change_notify(self)
  end

  def deliver_email_change_confirm!
    reset_new_email_token!
    Notifier.deliver_email_change_confirm(self)
  end

  def self.find_active_users
    find(:all, :conditions => "active = 't'", :order => "created_at DESC")
  end

  def rotate_tip_bundle!
    TipBundle.update(active_tip_bundle.id, :is_active => false)
    TipBundle.create(:fan => self) # TODO: we're changing the default behavior here
  end

  def active_tip_bundle
    tip_bundles.find(:first, :conditions => ["is_active = ?", true]) || TipBundle.new(:fan => self) # TODO: see below
  end

  def tip(url_string, description = 'new page', multiplier = 1)
    locator = Locator.find_or_init_by_url(url_string)
    amount_in_cents = self.tip_rate.amount_in_cents if self.tip_rate != nil
    if locator && amount_in_cents
      locator.page = Page.create(:description => description) unless locator.page

      tip = Tip.new(:locator         => locator,
                    :tip_bundle      => active_tip_bundle,
                    :multiplier      => multiplier,
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

  def reset_new_email_token!
    self.new_email_token = Authlogic::Random.hex_token[0..40]
    save
  end
end
