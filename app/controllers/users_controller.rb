class UsersController < ApplicationController
  filter_access_to :all
  def update
    @user = current_user
    @user.tip_preference_in_cents = params[:user][:tip_preference_in_cents]

    @user.save
    respond_to do |format|
      format.xml  { render :xml => @user.to_xml }
      format.json  { render :json => @user.to_json }
    end
  end
  def show
    if current_user
      @user = current_user
      @tip = Tip.new

      if params[:all]
        @tips = current_user.tips
      else
        @tips = current_user.active_tips
      end
    else
      @user = User.new
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

    if (!current_user.stripe_customer_id)
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

      if request.xhr?
        render :text => '<meta name="event_trigger" content="card_approved"/>'
      else
        redirect_to user_tips_url(current_user), :notice => "Thank you. We've emailed you a detailed reciept"
      end
    else
      if request.xhr?
        render :text => '<meta name="event_trigger" content="terms_declined"/>'
      else
        redirect_to user_tips_url(current_user), :notice => "we can not charge your card unless you accept the terms"
      end
    end
  rescue Stripe::CardError => e
    logger.error e.message

    if request.xhr?
      render :text => '<meta name="event_trigger" content="card_declined"/>'
    else
      redirect_to user_tips_url(current_user), :notice => "Your card was declined."
    end
  rescue Stripe::InvalidRequestError => e
    logger.error e.message
    if request.xhr?
      render :text => '<meta name="event_trigger" content="processing_error"/>'
    else
      redirect_to user_tips_url(current_user), :notice => "There was a processing error. Your credit card was not charged"
    end
  end
end
