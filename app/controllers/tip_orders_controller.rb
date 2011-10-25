class TipOrdersController < ApplicationController

  filter_access_to :all

  def new
    @tip_order = TipOrder.new
  end

  def create

  end


end