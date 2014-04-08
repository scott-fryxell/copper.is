class TipsController < ApplicationController
  filter_access_to :all

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
