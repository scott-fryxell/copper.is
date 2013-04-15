class OrdersController < ApplicationController
  # filter_resource_access

  def index
  end

  def show
    if params[:id] == 'current'
      render :action => 'data', :layout => false
    elsif params[:id] == 'paid'
      render :action => 'data', :layout => false
    elsif params[:id] == 'unpaid'
      render :action => 'data', :layout => false
    elsif params[:id] == 'declined'
      render :action => 'model', :layout => false
    else
      render :action => 'show', :layout => false
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def update
    # collect and save the parameters
    current_user.accept_terms = params[:terms]
    current_user.email = params[:email]

    if current_user.stripe_id
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.card = params[:stripe_token]
      customer.save
    else
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :description => "user.id=" + current_user.id.to_s
      )
      current_user.stripe_id = customer.id
    end

    current_user.save
    order = current_user.orders.find(params[:id]) || current_user.current_order

    if current_user.accept_terms
      if order.current?
        order.rotate!
        order.charge!
      else
        order.charge!
      end
      if order.paid?
        # OrderMailer.reciept(order).deliver
        render text:'<meta name="event_trigger" content="card_approved"/>'
      elsif order.denied?
        render text:'<meta name="event_trigger" content="card_declined"/>'
      else
        render text:'<meta name="event_trigger" content="processing_error"/>'
      end
    else
      render :text => '<meta name="event_trigger" content="terms_declined"/>'
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def destroy
  end
end
