class PagesController < ApplicationController

  def patch
    head :ok
  end

  def show
    @page = Page.find(params[:id])
  end

  # TODO: appcache methods could go into the application controller
  def collection_appcache
    render layout:false, content_type:'text/cache-manifest'
  end

  def member_appcache
    @page = Page.find(params[:id])
    render layout:false, content_type:'text/cache-manifest'
  end

end
