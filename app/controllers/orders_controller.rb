class OrdersController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @orders = Order.send(params[:state]).endless(params[:endless])
    elsif params[:user_id]
      @orders = Order.where(user_id:params[:user_id]).order("created_at DESC").endless(params[:endless])
    else
      @orders = Order.order("created_at DESC").endless(params[:endless])
    end
    render :action => 'index', :layout => false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def show
    @order = Order.find(params[:id])
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end
end
