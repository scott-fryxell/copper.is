class HomeController < ApplicationController
  respond_to :html
  caches_page :index, :blog, :terms, :privacy, :button,:authors

  def index
    render :action => 'index'
  end

  def blog
    render :action => 'blog'
  end

  def terms
    render :action => 'terms'
  end

  def privacy
    render :action => 'privacy'
  end

  def button
    render :action => 'button'
  end

  def authors
    render :action => 'authors'
  end

end