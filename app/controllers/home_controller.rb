class HomeController < ApplicationController
  def index
  end

  def weave
    render :action => 'weave.js', :layout => false
  end

  def agent
    render :action => 'agent', :layout => false
  end
end