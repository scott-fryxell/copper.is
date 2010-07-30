class ReportsController < ApplicationController

  def sites
    @tips = Site.most_tips
    @revenue = Site.most_revenue
  end

  def pages
    @tips = Page.most_tips
    @revenue = Page.most_revenue
  end

end