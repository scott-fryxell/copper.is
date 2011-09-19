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


  def terms
    render :action => 'terms'
  end

  def privacy
    render :action => 'privacy'
  end

end