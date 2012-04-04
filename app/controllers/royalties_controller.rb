class RoyaltiesController < ApplicationController
  filter_access_to :all
  
  def index
    @user = current_user
    @royalties = @user.royalties.all

    # respond_to do |format|
      # format.html # index.html.erb
      # format.xml  { render :xml => @royalties.to_xml }
      # format.json  { render :json => @royalties.to_json }
    # end
  end
end
