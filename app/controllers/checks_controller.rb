class ChecksController < ApplicationController
  filter_access_to :all

  def index
    case params[:s]
    when 'paid'
      @checks = current_user.checks.paid.all
    when 'earned'
      @checks = current_user.checks.earned.all
    when 'cashed'
      @checks = current_user.checks.cashed.all
    else
      @checks = current_user.checks.all
    end
  end
  
  def create
    render nothing:true, status:403
  end
  
  def show
    if params[:id] == 'current'
      @check = current_user.checks.earned.first
    else
      @check = current_user.checks.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end
  
  def new
    render nothing:true, status:403
  end
  
  def edit
    render nothing:true, status:403
  end
  
  def update
    render nothing:true, status:403
  end
  
  def destroy
    render nothing:true, status:403
  end
end
