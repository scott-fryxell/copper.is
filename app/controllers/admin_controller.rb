class AdminController < ApplicationController
  filter_access_to :claim_facebook_pages, :require => :read
  filter_access_to :admin, :require => :manage
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
