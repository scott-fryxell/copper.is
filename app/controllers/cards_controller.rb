class CardsController < ApplicationController
  filter_access_to :all

  def show
    # should return the current credit card
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    respond_to do |format|
      format.json { render :json => customer }
    end
  end

  def update
    # should update the users credit card info
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.card = params[:card_token] # obtained with Stripe.js
    customer.save
    render nothing:true, status:200
  end

  def create
    # should create a stripe customer from a token
    customer = Stripe::Customer.create(
      :description => "user_id=#{current_user.id}",
      :card => params[:card_token] # obtained with Stripe.js
    )
    current_user.stripe_id = customer.id
    current_user.save
    respond_to do |format|
      format.json { render :json => customer }
    end
  end

  def destroy
    # should remove a users credit card info
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.delete
    render nothing:true, status:200
  end
end