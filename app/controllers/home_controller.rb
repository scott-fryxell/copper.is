class HomeController < ApplicationController
  respond_to :html

  def index
    if current_user
      @tip = Tip.new
      respond_with(@tip)
    end
  end

  def blog
    render :action => 'blog', :layout => true
  end

  def embed_iframe
    render :action => 'embed_iframe.js', :layout => false
  end

  def agent
    render :action => 'agent', :layout => false
  end

  def terms
    render :action => 'terms'
  end

  def privacy
    render :action => 'privacy'
  end

end