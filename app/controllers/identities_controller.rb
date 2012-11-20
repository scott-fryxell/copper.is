class IdentitiesController < ApplicationController
  filter_resource_access

  def index
    @identities = current_user.identities
  end

  def new
  end

  def show
    @identity = current_user.identities.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def edit
  end

  def create
  end
  
  def update
  end

  def destroy
    identity = Identity.find(params[:id])
    identity.remove_user!
    render nothing:true, status:200
  end
end
