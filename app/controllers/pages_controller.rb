class PagesController < ApplicationController
  filter_resource_access

  def index
    @pages = Page.all
    respond_to do |format|
      format.html
      format.json { render :json => @pages }
    end
  end

  def show
    @page = Page.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @page }
    end
  end

  def new
    render nothing:true, status:403
  end

  def create
    render nothing:true, status:403
  end

  def destroy
    render nothing:true, status:403
  end
end
