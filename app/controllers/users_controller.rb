class UsersController < ApplicationController
  filter_access_to :all
  def update
    @user = current_user
    @user.update_attributes(params[:user])

    @user.save
    respond_to do |format|
      format.xml  { render :xml => @user.to_xml }
      format.json  { render :json => @user.to_json }
    end
  end
  def show
    @user = current_user
    @tip = Tip.new

    if params[:all] == 'true'
      @tips = current_user.tips
    else
      @tips = current_user.active_tips
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user.to_xml }
      format.json  { render :json => @user.to_json }
    end
  end
  def pay
    # collect and save the parameters
    current_user.accept_terms = params[:terms]
    current_user.email = params[:email]
    current_user.automatic_rebill = params[:rebill]

    if current_user.stripe_customer_id
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      customer.card = params[:stripe_token]
      customer.save
    else
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :description => "user.id=" + current_user.id.to_s
      )
      current_user.stripe_customer_id = customer.id
    end

    current_user.save
    order = current_user.active_tip_order

    if(current_user.accept_terms)
      current_user.active_tip_order.charge
      OrderMailer.reciept(order).deliver
      render :text => '<meta name="event_trigger" content="card_approved"/>'
    else
      render :text => '<meta name="event_trigger" content="terms_declined"/>'
    end
  rescue Stripe::CardError => e
    render :text => '<meta name="event_trigger" content="card_declined"/>'
  rescue Stripe::InvalidRequestError => e
    render :text => '<meta name="event_trigger" content="processing_error"/>'
  end
  def author
    render 'users/author'
  end
end

