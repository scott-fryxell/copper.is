class OrdersController < ApplicationController
  filter_access_to :all

  def index
    puts params
  end

  def show
    if params[:id] == 'current'
      render :action => 'index', :layout => false
    elsif params[:id] == 'paid'
      render :action => 'index', :layout => false
    elsif params[:id] == 'unpaid'
      render :action => 'index', :layout => false
    elsif params[:id] == 'declined'
      render :action => 'index', :layout => false
    else
      render :action => 'show', :layout => false
    end
  end

  def update
  end

  def destroy
  end
end
