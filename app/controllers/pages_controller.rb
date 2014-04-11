class PagesController < ApplicationController
  filter_access_to :all
  filter_access_to :appcache, :require => :read

  def index

  end


  def appcache
    render action:'appcache', layout:false, content_type:'text/cache-manifest'

  end
end
