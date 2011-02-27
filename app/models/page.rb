class Page < ActiveRecord::Base

  has_many :locators
  has_many :tips, :through => :locators
  has_and_belongs_to_many :royalty_bundles
  validates_presence_of :description

  # scope :old_most_tips, :include => [:tips], 
  #         :conditions => "tips.locator_id = locators.id", 
  #         :group => "pages.id", 
  #         :order => "count(tips.id) DESC"

  # select pages that have the most tips
  scope :most_tips, order

  def tips_earned
    tips.count
  end

  def revenue_earned # TODO straight SQL would probably be faster
    royalty_bundles.inject(0) { |sum, bundle| sum + bundle.tip_royalties.sum('amount_in_cents') }
  end
  
  # We could (and used to) do this as a named scope, but PostgreSQL, rightly,
  # complains about loose use of grouping and aggregation, and trying to horn
  # in the correct subselect into a named scope got grotesque pretty quickly.
  def self.most_tips
    Page.find_by_sql <<-CHUBBA
        SELECT pages.*
          FROM pages,
               (SELECT pages.id       page_id,
                       COUNT(tips.id) num_tips
                  FROM pages
            INNER JOIN locators ON locators.page_id = pages.id
            INNER JOIN tips     ON tips.locator_id  = locators.id
              GROUP BY pages.id) tip_counts
         WHERE tip_counts.page_id = pages.id
      ORDER BY tip_counts.num_tips DESC
      LIMIT 8
    CHUBBA
  end

  def self.most_revenue
    Page.find_by_sql <<-WHANKABOOM
        SELECT p.id,
               p.description,
               SUM(tr.amount_in_cents) total_revenue
          FROM pages p,
               pages_royalty_bundles prb,
               tip_royalties tr
         WHERE p.id = prb.page_id
           AND prb.royalty_bundle_id = tr.royalty_bundle_id
           AND tr.amount_in_cents > 0
      GROUP BY p.id,
               p.description
      ORDER BY total_revenue desc
      LIMIT 8
    WHANKABOOM
  end

  def primary_locator
    locators.first
  end
end
