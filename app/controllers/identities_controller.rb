class IdentitiesController < ApplicationController
  filter_access_to :all
  
  def index
  end
  
  def destroy 
    identity = Identity.find(params[:id])
    identity.destroy
    redirect_to user_identities_path(current_user), notice: "Removed that Identity"
  end
end
