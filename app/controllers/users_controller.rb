class UsersController < ApplicationController

  filter_access_to :all

  def new
    @user = User.new
  end

  def edit
    @user = current_user
    @user.valid?
  end

  def update
    @user = current_user
    @user.tip_preference_in_cents = params[:user][:tip_preference_in_cents]

    if @user.save
      if request.xhr?
        render :action => 'update', :layout => false
      else
        flash[:notice] = "Your account has been updated."
        render :action => 'edit'
      end
    else
      if request.xhr?
        render :action => 'failed_update', :layout => false
      else
        flash[:notice] = "Unable to save user changes."
        render :action => 'edit'
      end
    end
  end

  def show
    @user = current_user

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

    if (!current_user.stripe_customer_id)
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :description => "user.id=" + current_user.id.to_s
      )

      current_user.stripe_customer_id = customer.id
    end
    
    current_user.save
    
    order = current_user.active_tip_order

    if(current_user.accept_terms? && current_user.stripe_customer_id)
      current_user.active_tip_order.charge
      OrderMailer.reciept(order).deliver
      redirect_to tips_url, :notice => "Thank you. We've emailed you a detailed reciept"
    else
      redirect_to tips_url, :notice => "There was a problem processing your order. please try again later."
    end

  # catch any errors and handle them.
  rescue Stripe::InvalidRequestError => e
    logger.error e.message
    redirect_to tips_url, :notice => "There was a problem with your credit card"
  end

end
