class PagesController < ApplicationController
  filter_resource_access
  
  def index
    @pages = Page.all
  end
  
  def show
    @page = Page.find(params[:id])
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
