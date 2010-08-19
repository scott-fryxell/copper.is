class OrdersController < ApplicationController
  def new
    @order = Order.new
    @order.account = Account.new
    @order.account.billing_address = Address.new
  end

  def create
    @address = Address.create(params[:billing_address])

    @account = Account.new(params[:account])
    @account.user = current_user
    @account.billing_address = @address
    @account.save

    @order = Order.new()
    @order.amount_in_cents = params[:order][:amount_in_cents]
    @order.ip_address = request.remote_ip
    @order.account = @account

    if params[:place_order] != "1" # Prepare the order
      if @order.valid?
        @billing_address = params[:billing_address]
        @account = params[:account]
        @order = params[:order]
        render :action => "confirm"
      else
        # notify of bad values
        render :action => "new"
      end
    elsif params[:place_order] == "1" # Place the order
      if @order.place_order
        flash[:notice] = "successful purchase"
        render :action => "success"
      else
        flash[:notice] = "order failed"
        render :action => "new"
      end
    end
  end

end