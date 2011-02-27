class Site < ActiveRecord::Base
  validates_presence_of   :fqdn
  validates_uniqueness_of :fqdn
  validates_format_of     :fqdn, :with => /^[a-z0-9\-\.]+$/i

  has_many :locators
  has_many :tips, :through => :locators
  has_and_belongs_to_many :royalty_bundles
  has_many :tip_royalties, :through => :royalty_bundles # TODO understand why this doesn't work.

  # scope :limited, lambda { |*num| { :limit => num.flatten.first || (defined?(per_page) ? per_page : 10) } }

  # TODO finish implementing offset named_scope to assist in pagination
  # named_scope :offsetter, lambda { |*num|
  #     { :offset => (num.flatten.first || (defined?(page_num) ? page_num : 0)) *  }
  #   }

  def tips_earned
    tips.count
  end

  # We could (and used to) do this as a named scope, but PostgreSQL, rightly,
  # complains about loose use of grouping and aggregation, and trying to horn
  # in the correct subselect into a named scope got grotesque pretty quickly.
  def self.most_tips
    Site.find_by_sql <<-CHUBBA
        SELECT sites.*
          FROM sites,
               (SELECT sites.id       site_id,
                       COUNT(tips.id) num_tips
                  FROM sites
            INNER JOIN locators ON locators.site_id = sites.id
            INNER JOIN tips     ON tips.locator_id  = locators.id
              GROUP BY sites.id) tip_counts
         WHERE tip_counts.site_id = sites.id
      ORDER BY tip_counts.num_tips DESC
    CHUBBA
  end

  #TODO review performance of 'revenue_earned' vs 'revenue_earned_sql'
  def revenue_earned
    royalty_bundles.inject(0) { |sum, bundle| sum + bundle.tip_royalties.sum('amount_in_cents') }
  end

  def revenue_earned_sql
    revenooer = Site.find_by_sql <<-SHONKY
      SELECT SUM(tr.amount_in_cents) total_revenue
        FROM tip_royalties tr
       WHERE tr.royalty_bundle_id IN (SELECT rbs.royalty_bundle_id
                                        FROM royalty_bundles_sites rbs
                                       WHERE rbs.site_id = #{self.id})
    SHONKY

    revenooer.first.total_revenue
  end

  def self.most_revenue
    Site.find_by_sql <<-HOOPTY
        SELECT s.fqdn,
               SUM(tr.amount_in_cents) total_revenue
          FROM sites s,
               royalty_bundles_sites rbs,
               tip_royalties tr
         WHERE s.id = rbs.site_id
           AND rbs.royalty_bundle_id = tr.royalty_bundle_id
           AND tr.amount_in_cents > 0
      GROUP BY s.fqdn
      ORDER BY SUM(tr.amount_in_cents) DESC
    HOOPTY
  end
end
