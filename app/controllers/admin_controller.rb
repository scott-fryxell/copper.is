class AdminController < ApplicationController
  # filter_access_to :index, :require => :read

  def index
  
  end

  def orders
    render :action => 'orders', :layout => false
  end

end
