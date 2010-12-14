class HomeController < ApplicationController
  def index

    if current_user
      @tip = Tip.new

      respond_to do |format|
        format.html # index.html.erb
      end
    end

  end

  def blog
    render :action => 'blog', :layout => true
  end


  def weave
    render :action => 'weave.js', :layout => false
  end

  def agent
    render :action => 'agent', :layout => false
  end
end