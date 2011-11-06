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

    current_user.save
    
    current_user.active_tip_order.charge(params[:stripe_token])
    
    # email customer their reciept
    
    redirect_to tips_url, :notice => "Thank you. We've emailed you a detailed reciept"
  end
end
