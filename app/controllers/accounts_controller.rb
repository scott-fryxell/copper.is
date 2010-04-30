class AccountsController < ApplicationController
  
  filter_resource_access
  
  def index
    @accounts = Account.find_all_by_user_id(current_user)
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def new
    @account = Account.new
    @account.address = Address.new
    
    @current_user = current_user
  end
  
  def create
    @account = Account.new(params[:account])
    @account.user = current_user
    if @account.save
      flash[:notice] = "Successfully created account."
      redirect_to @account
    else
      render :action => 'new'
    end
  end
  
  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = "Successfully updated account."
      redirect_to @account
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    flash[:notice] = "Successfully destroyed account."
    redirect_to accounts_url
  end
end
