class OrdersController < ApplicationController
  filter_access_to :all

  def index
    puts params
    @state = "unpaid" unless params[:when]
    render :action => 'index', :layout => false if request.headers['retrieve_as_data']
  end

  def show
    render :action => 'show', :layout => false
  end

  def update
  end

  def destroy
  end
end
