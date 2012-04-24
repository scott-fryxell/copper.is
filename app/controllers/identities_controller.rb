class IdentitiesController < ApplicationController
  filter_access_to :all
  
  def index

  end
  
  def show
    @identity = Identity.find(params[:id])
  end
  
  def destroy 
    identity = Identity.find(params[:id])
    identity.destroy
    redirect_to user_identities_path(current_user), notice: "Removed that Identity"
  end
  
  def wanted
    @wanted = Identity.wanted.all
  end
  
end
