class OrdersController < ApplicationController
  filter_resource_access
  
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(params[:order])
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        render :action => "success"
      else
        render :action => "failure"
      end
     else
      render :action => 'new'
    end
  end
end
