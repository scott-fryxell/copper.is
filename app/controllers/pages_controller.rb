class PagesController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @pages = Page.send(params[:state]).limit(25)  
    elsif params[:author_id]
      @pages = Page.where(author_id:params[:author_id])
    end
    render :action => 'index', :layout => false if request.headers['retrieve_as_data']
  end

  def show
    @page = Page.where(id:params[:id]).first
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end

  def new
  end

  def create
  end

  def destroy
  end
end
