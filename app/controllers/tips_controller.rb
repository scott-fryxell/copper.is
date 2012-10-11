class TipsController < ApplicationController
  filter_resource_access

  def index
    if params[:user_id]
      @tips = current_user.current_tips
    else
      @tips = Tip.trending
    end
  end

  def show

  end

  def new
    render action:'new', layout:false
  end

  def create
    @tip = current_user.tip(params[:tip])
    @tip.save
    render nothing:true, status:200
  rescue ActiveRecord::RecordInvalid
    render nothing:true, status:403
  end

  def edit
    render nothing:true
  end

  def update
    if (params[:tip][:amount_in_cents] && params[:tip][:amount_in_cents] != "" and @tip.order.current? and @tip.user == current_user)
      @tip.amount_in_cents = params[:tip][:amount_in_cents]
      @tip.save
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:403
  end

  def destroy
    if(@tip.order.user == current_user and @tip.order.current?)
      @tip.destroy
    end
    render nothing:true, status:200
  rescue CantDestroyException
    redirect_to tips_path, notice:'Tips can not be changed after they have been paid for'
  end

  protected

  def load_tip
    @page = Page.find(params[:page_id]) if params[:page_id]
    @user = User.find(params[:user_id]) if params[:user_id]
    @tip = Tip.find(params[:id])
  end
  def new_tip
    @tip = Tip.new(params[:tip])
  end
end
