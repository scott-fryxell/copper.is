class ChecksController < ApplicationController
  filter_access_to :all

  def index
    case params[:s]
    when 'paid'
      @checks = current_user.checks.paid.endless(params[:endless])
    when 'earned'
      @checks = current_user.checks.earned.endless(params[:endless])
    when 'cashed'
      @checks = current_user.checks.cashed.endless(params[:endless])
    else
      @checks = current_user.checks.endless(params[:endless])
    end
  end

  def show
    @check = current_user.checks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

end