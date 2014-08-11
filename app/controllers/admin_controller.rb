class AdminController < ApplicationController

  def index
  end

  def ping
    render action:'ping', layout:false
  end

  def test
    render :action => 'test', :layout => false
  end

end
