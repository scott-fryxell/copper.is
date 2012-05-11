class UsersController < ApplicationController
  filter_access_to :all

  def index
    redirect_to root_path
  end

  def new
    redirect_to root_path
  end

  def create
    redirect_to root_path
  end

  def update
    if @user = current_user
      if params[:id] == 'current' or @user.id.to_s == params[:id]
        @user.update_attributes(params[:user])
        @user.save!
        render nothing:true
      else
        render nothing:true, status:401
      end
    else
      render nothing:true, status:401
    end
  end

  def edit
    if @user = current_user
      if params[:id] == 'current' or @user.id.to_s == params[:id]
        if params[:author]
          render 'users/author'
        end

        @tips = @user.tips.all
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  # def pay
  #   # collect and save the parameters
  #   current_user.accept_terms = params[:terms]
  #   current_user.email = params[:email]
  #   current_user.automatic_rebill = params[:rebill]

  #   if current_user.stripe_customer_id
  #     customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
  #     customer.card = params[:stripe_token]
  #     customer.save
  #   else
  #     customer = Stripe::Customer.create(
  #       :card => params[:stripe_token],
  #       :description => "user.id=" + current_user.id.to_s
  #     )
  #     current_user.stripe_customer_id = customer.id
  #   end

  #   current_user.save
  #   order = current_user.current_order

  #   if current_user.accept_terms
  #     order.rotate!
  #     order.charge!
  #     if order.paid?
  #       OrderMailer.reciept(order).deliver
  #       render :text => '<meta name="event_trigger" content="card_approved"/>'
  #     elsif order.denied?
  #       render :text => '<meta name="event_trigger" content="card_declined"/>'
  #     else
  #      render :text => '<meta name="event_trigger" content="processing_error"/>'
  #     end

  #   else
  #     render :text => '<meta name="event_trigger" content="terms_declined"/>'
  #   end
  # end
end

