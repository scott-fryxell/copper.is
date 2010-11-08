class HomeController < ApplicationController
  def index
    @most_tips = Page.most_tips

    # temporarly using most_tips will switch it when we actually have some data
    @most_revenue = Page.most_tips
    #@most_revenue = Page.most_revenue
  end
end