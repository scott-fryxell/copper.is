class HomeController < ApplicationController
  def index
    @pages = Page.most_tips
  end
end