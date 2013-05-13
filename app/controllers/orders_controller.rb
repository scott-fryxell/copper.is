class OrdersController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @orders = Order.send(params[:state]).limit(25)  
    elsif params[:user_id]
      @orders = Order.where(user_id:params[:user_id]).order("created_at DESC")
    end
    render :action => 'index', :layout => false if request.headers['retrieve_as_data']
  end

  def show
    @order = Order.where(id:params[:id]).first
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end

  def update
  end

  def destroy
  end
end
