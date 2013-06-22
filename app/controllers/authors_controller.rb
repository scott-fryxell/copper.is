class AuthorsController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @authors = Author.send(params[:state]).endless(params[:endless])
    elsif params[:user_id]
      @authors = Author.where(user_id:params[:user_id]).endless(params[:endless])
    elsif params[:page_id]
      @authors = Author.where(page_id:params[:page_id]).endless(params[:endless])
    else
      @authors = Author.twitter.stranger.tips_waiting.endless(params[:endless])
    end
    render action:'index', layout:false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def new
  end

  def show
    @author = Author.where(id:params[:id]).first
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
    author = Author.find(params[:id])
    author.remove_user!
    render nothing:true, status:200
  end
end
