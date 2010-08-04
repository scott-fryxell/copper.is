class Tip < ActiveRecord::Base
  belongs_to :tip_bundle
  belongs_to :locator, :counter_cache => true
  has_one :site, :through => :locator
  has_one :tip_royalty

  validates_presence_of :tip_bundle
  validates_presence_of :locator

  validates_numericality_of :multiplier, :only_integer => true, :greater_than => 0

  # minimum value per tip, in cents
  MINIMUM_TIP_VALUE = 1

  before_save do |tip|
    bundle = tip.tip_bundle
    if (bundle.allocated_funds / (bundle.tip_points + tip.multiplier)) < MINIMUM_TIP_VALUE
      raise(InsufficientFunds, "fan needs to add more money to tip bundle to continue tipping")
    end
  end

  def self.build(current_user, uri)
    tip = Tip.new
    tip.tip_bundle = current_user.tip_bundles.find_by_is_active(true)
    location = Locator.parse(uri)
    tip.locator = Locator.find_or_create_by_scheme_and_userinfo_and_port_and_registry_and_path_and_opaque_and_query_and_fragment_and_site_id_and_page_id(location.scheme, location.userinfo, location.port, location.registry, location.path, location.opaque, location.query, location.fragment, location.site.id, location.page.id)
    tip
  end

  def amount_in_cents
    tip_bundle.cents_per_tip_point * multiplier
  end
end
