class AdminController < ApplicationController
  filter_access_to :index, :require => :manage
  respond_to :html

  def index
  end


  def ping
    Page.count
    render action:'ping', layout:false
  end

  def test
    render :action => 'test', :layout => false
  end


end
