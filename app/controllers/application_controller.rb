class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :item_scope

  private

  def current_user
    @current_user ||= User.find(cookies[:user_id]) if cookies[:user_id]
  end

  def item_scope
    type = params[:controller].parameterize
    id = params['id']
    if id
      item_id= "itemid='/#{type}/#{id}'"
    end
    "itemscoped itemtype='#{type}' #{item_id}"
  end

  protected

  def permission_denied
    if current_user
      respond_to do |format|
        format.html { render nothing:true, status:403 }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    else
      respond_to do |format|
        format.html { render nothing:true, status:401 }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end
  end

end
