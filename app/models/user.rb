class User < ActiveRecord::Base

  has_many :tips, :through => :tip_bundles
  has_many :tip_bundles, :foreign_key => "fan_id"

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
    bundle = active_tip_bundle
    if bundle
      tips = Tip.find_all_by_tip_bundle_id(bundle.id, :order => "created_at DESC")
    else
      []
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
