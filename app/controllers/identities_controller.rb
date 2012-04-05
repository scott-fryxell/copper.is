class IdentitiesController < ApplicationController
  filter_access_to :all
  
  def index
  end
  
  def delete 
    identity = Identity.find(params[:id])
    identity.destroy
    render :nothing => true, :status => :ok
  end
end
