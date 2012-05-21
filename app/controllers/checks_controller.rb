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
    respond_to do |format|
      format.html
      format.json { render :json => @checks }
    end
  end

  def create
    render nothing:true, status:403
  end

  def show
    @check = current_user.checks.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @check }
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
