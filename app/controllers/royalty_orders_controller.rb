class RoyaltyOrdersController < ApplicationController
  filter_access_to :all
  
  def index
    @royalty_orders = current_user.royalty_orders.all
  end
end