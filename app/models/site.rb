class Site < ActiveRecord::Base
  validates_presence_of   :fqdn
  validates_uniqueness_of :fqdn
  validates_format_of     :fqdn, :with => /^[a-z0-9\-\.]+$/i

  has_many :locators
  has_many :tips, :through => :locators
  has_and_belongs_to_many :royalty_bundles
  has_many :tip_royalties, :through => :royalty_bundles # TODO understand why this doesn't work.

  named_scope :most_tipped, :include => [:tips], :group => "sites.fqdn", :order => "count(tips.id) DESC"
  named_scope :limited, lambda { |*num|
    { :limit => num.flatten.first || (defined?(per_page) ? per_page : 10) }
  }
  # TODO finish implementing offset named_scope to assist in pagination
  # named_scope :offsetter, lambda { |*num|
  #     { :offset => (num.flatten.first || (defined?(page_num) ? page_num : 0)) *  }
  #   }

  def tips_earned
    tips.count
  end

  # TODO discuss performance of SQL vs. ActiveRecord vs named_scope
  def self.most_tipped_sql(page_size=10, page_number=0)
    # Replaced by named_scope :most_tipped
    # SQL way returns hash of two values, the exact values the report wants.
    # The two method arguments make this vunerable to SQL injection attack.
    Site.find_by_sql("
    select s.fqdn site, count(t.id) tip_count
    from sites s, locators l, tips t
    where s.id = l.site_id
    and t.locator_id = l.id
    group by s.fqdn
    order by count(t.id) desc
    limit '#{page_size}'
    offset '#{page_number*page_size}'
    ")
  end

  # see most_tipped_sql
  def self.most_tipped_activerecord(page_size=10, page_number=0)
    # Replaced by named_scope :most_tipped
    # ActiveRecord version returns hash of Objects, can then output whatever you want in the report, but might take longer than SQL to then calculate tips count again
    # The two method arguments make this vunerable to SQL injection attack.
    Site.find(:all,
    :include => [:tips],
    :group => "sites.fqdn",
    :order => "count(tips.id) DESC",
    :limit => page_size,
    :offset => page_size * page_number
    )
  end
  
  #TODO review performance of 'revenue_earned' vs 'revenue_earned_sql'
  def revenue_earned
    @revenue = 0
    @rb = self.royalty_bundles
    @rb.each do |x|
      @bundle = RoyaltyBundle.find_by_id(x.id)
      @revenue += @bundle.tip_royalties.sum('amount_in_cents')
    end
    return @revenue
  end

  def revenue_earned_sql
    @result = Site.find_by_sql("
    select sum(tr.amount_in_cents) total_revenue
    from tip_royalties tr
    where tr.royalty_bundle_id in
    (select rbs.royalty_bundle_id from royalty_bundles_sites rbs where rbs.site_id = #{self.id})
    ")
    return @result[0].total_revenue
  end

  def self.most_revenue
    Site.find_by_sql("
    select s.fqdn, sum(tr.amount_in_cents) total_revenue
    from sites s, royalty_bundles_sites rbs, tip_royalties tr
    where s.id = rbs.site_id
    and rbs.royalty_bundle_id = tr.royalty_bundle_id
    group by s.fqdn
    order by sum(tr.amount_in_cents) desc
    ")
  end

end
