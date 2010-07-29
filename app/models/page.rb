class Page < ActiveRecord::Base
  has_many :locators
  has_many :tips, :through => :locators
  has_and_belongs_to_many :royalty_bundles

  named_scope :most_tips, :include => [:tips], :group => "pages.id", :order => "count(tips.id) DESC"

  validates_presence_of :description

  def tips_earned
    tips.count
  end

  def revenue_earned # TODO find_by_sql would probably be faster
    @revenue = 0
    @rb = self.royalty_bundles
    @rb.each do |x|
      @bundle = RoyaltyBundle.find_by_id(x.id)
      @revenue += @bundle.tip_royalties.sum('amount_in_cents')
    end
    return @revenue
  end

  def self.most_revenue # TODO review SQL for efficiency vs. activerecord
    Page.find_by_sql("
    select p.id, p.description, sum(tr.amount_in_cents) total_revenue
    from pages p, pages_royalty_bundles prb, tip_royalties tr
    where p.id = prb.page_id
    and prb.royalty_bundle_id = tr.royalty_bundle_id
    group by p.id, p.description
    order by sum(tr.amount_in_cents) desc
    ")
  end

end
