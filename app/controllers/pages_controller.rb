class PagesController < ApplicationController
  filter_access_to :all
  filter_access_to :application_appcache, :require => :read
  filter_access_to :collection_appcache, :require => :read
  filter_access_to :member_appcache, :require => :read


  def application_appcache
    expires_in 1.second, :public => true
    render action:'appcache',layout:false, content_type:'text/cache-manifest'
  end

  def collection_appcache
    expires_in 1.second, :public => true
    render layout:false, content_type:'text/cache-manifest'
  end

  def member_appcache
    expires_in 1.second, :public => true
    render layout:false, content_type:'text/cache-manifest'
  end

end
