class ReportsController < ApplicationController
  def pages
    # placeholder
  end

  def publishers
    #placeholder
  end

  def sites_most_tips
    @sites = Site.most_tips
    redirect_to sites_most_tips_url
  end

  def sites_most_revenue
    @sites = Site.most_revenue
    redirect_to sites_most_revenue_url
  end

  def pages_most_tips
    @pages = Page.most_tips
    redirect_to pages_most_tips_url
  end

  def pages_most_revenue
    @pages = Page.most_revenue
    redirect_to pages_most_revenue_url
  end

end