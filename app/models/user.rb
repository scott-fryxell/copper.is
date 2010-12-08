class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # c.validations_scope = :company_id # for available Authlogic options see documentation in the various Config modules of Authlogic::ActsAsAuthentic
    # enable Authlogic_RPX account merging (false by default, if this statement is not present)
    # c.account_merge_enabled true
    # set Authlogic_RPX account mapping mode
    c.account_mapping_mode :internal
  end

  has_many :tips, :through => :tip_bundles
  has_many :tip_bundles, :foreign_key => "fan_id"

  has_and_belongs_to_many :roles

  #AuthLogic validate the uniqueness of the email field by convention
  #validates_uniqueness_of :email

  attr_accessible :email

  def active_tips
    bundle = active_tip_bundle
    if bundle
      tips = Tip.find_all_by_tip_bundle_id(bundle.id, :order => "created_at DESC")
    else
      []
    end
  end

  def active_tip_total_in_cents 
    active_tip_bundle.tip_points
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

  def rotate_tip_bundle!
    TipBundle.update(active_tip_bundle.id, :is_active => false)
    TipBundle.create(:fan => self) # TODO: we're changing the default behavior here
  end

  def active_tip_bundle
    tip_bundles.find(:first, :conditions => ["is_active = ?", true]) || TipBundle.new(:fan => self) # TODO: see below
  end

  def tip(url_string, description = 'new page')
    locator = Locator.find_or_init_by_url(url_string)
    amount_in_cents = self.tip_preference_in_cents

    if locator && amount_in_cents
      locator.page = Page.create(:description => description) unless locator.page

      tip = Tip.new(:locator         => locator,
                    :tip_bundle      => active_tip_bundle,
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
