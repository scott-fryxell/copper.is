class TipsController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @tips = Tip.send(params[:state]).endless(params[:endless])
    elsif params[:user_id]
      @tips = User.find(params[:user_id]).tips.endless(params[:endless])
    elsif params[:order_id]
      @tips = Tip.where(order_id:params[:order_id]).endless(params[:endless])
    elsif params[:page_id]
      @tips = Tip.where(page_id:params[:page_id]).endless(params[:endless])
    else
      @tips = Tip.promised.endless(params[:endless])
    end
    render action:'index', layout:false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def show
    @tip = Tip.find(params[:id])
    render action:'show', layout:false if request.headers['retrieve_as_data']
  end

  def new
    if current_user
      render action:'new', layout:'tip_layout'
    else
      render action:'sign_in', layout:'tip_layout'
    end
  end

  def create
    @tip = current_user.tip(params[:tip])
    render text:"/tips/#{@tip.id}", status:200
  rescue ActiveRecord::RecordInvalid
    render nothing:true, status:403
  end

  def update

    @tip = Tip.find(params[:id])

    if @tip.user != current_user
      return render nothing:true, status:403
    end

    if (params[:tip][:amount_in_cents] && params[:tip][:amount_in_cents] != "" and @tip.order.current? and @tip.user == current_user)
      @tip.amount_in_cents = params[:tip][:amount_in_cents]
      @tip.save
    end
    render nothing:true, status:200
  end

  def destroy
    @tip = Tip.find(params[:id])
    if(@tip.order.user == current_user and @tip.order.current?)
      @tip.destroy
    end
    render nothing:true, status:200
  rescue CantDestroyException
    redirect_to tips_path, notice:'Tips can not be changed after they have been paid for'
  end

end
