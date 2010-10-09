class ReportsController < ApplicationController
  def sites
    @most_tipped  = Site.most_tips
    @most_revenue = Site.most_revenue
  end

  def pages
    @most_tipped  = Page.most_tips
    @most_revenue = Page.most_revenue
  end
end