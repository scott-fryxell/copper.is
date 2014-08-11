class TipsController < ApplicationController

  protect_from_forgery except: [:iframe, :new]


  def create
    @tip = current_user.tip(params[:tip])
    head :create, location: "/tips/#{@tip.id}"
  rescue ActiveRecord::RecordInvalid
    head :bad_request
  end

  def update

    @tip = Tip.find(params[:id])

    if @tip.user != current_user
      return render nothing:true, status:403
    end

    if (params[:tip][:amount_in_cents] and
        params[:tip][:amount_in_cents] != "" and
        @tip.order.current? and
        @tip.user == current_user)

      @tip.amount_in_cents = params[:tip][:amount_in_cents]
      @tip.save
    end
    head :ok
  end

  def destroy
    @tip = Tip.find(params[:id])
    if(@tip.order.user == current_user and @tip.order.current?)
      @tip.destroy
    end
    head :ok
  rescue CantDestroyException
    redirect_to tips_path, notice:'Tips can not be changed after they have been paid for'
  end

  def iframe
    response.headers['Cache-Control'] = 'public, max-age=300'
    render :action => 'embed_iframe', :format => [:js], :layout => false
  end

end
