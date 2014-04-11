class PagesController < ApplicationController
  filter_access_to :all
  filter_access_to :appcache, :require => :read

  def index

  end


  def appcache
    expires_in 1.second, :public => true
    render action:'appcache', layout:false, content_type:'text/cache-manifest'

  end
end
