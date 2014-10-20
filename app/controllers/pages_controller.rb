class PagesController < ApplicationController
  before_action :bust_cache, only:[:collection_appcache, :member_appcache]

  def patch
    head :ok
  end

  def show
    @page = Page.find(params[:id])
    fresh_when @page
  end

  # TODO: appcache methods could go into the application controller
  def collection_appcache
    render layout:false, content_type:'text/cache-manifest'
  end

  def member_appcache
    @page = Page.find(params[:id])
    # @page = Page.find(24)
    render layout:false, content_type:'text/cache-manifest'
  end

end
