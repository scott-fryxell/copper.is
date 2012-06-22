class ChecksController < ApplicationController
  filter_resource_access

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
  end

  def show
    @check = current_user.checks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
