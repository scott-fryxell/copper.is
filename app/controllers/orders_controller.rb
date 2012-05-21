class OrdersController < ApplicationController
  filter_resource_access

  def index
    case params[:s]
    when 'paid'
      @orders = current_user.orders.paid.all
    when 'unpaid'
      @orders = current_user.orders.unpaid.all
    when 'denied'
      @orders = current_user.orders.denied.all
    else
      @orders = current_user.orders.all
    end
    respond_to do |format|
      format.html
      format.json { render :json => @orders }
    end
  end

  def show
    if params[:id] == 'current'
      @order = current_user.current_order
    else
      @order = current_user.orders.find(params[:id])
    end
    respond_to do |format|
      format.html
      format.json { render :json => @order }
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def edit
    if params[:id] == 'current'
      @order = current_user.current_order
    else
      @order = current_user.orders.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def update
    render nothing:true, status:403
  end

  def new
    renders nothing:true, status:403
  end

  def create
    renders nothing:true, status:403
  end

  def destroy
    renders nothing:true, status:403
  end
end
