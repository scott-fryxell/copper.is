class IdentitiesController < ApplicationController
  filter_resource_access

  def index
    @identities = current_user.identities
  end

  def new
    render nothing:true, status:403
  end

  def show
    @identity = current_user.identities.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def edit
    render nothing:true, status:403
  end

  def update
    render nothing:true, status:403
  end

  def destroy
    identity = Identity.find(params[:id])
    identity.destroy
    redirect_to identities_path, notice: "Removed that Identity"
  end
end
