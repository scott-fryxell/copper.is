class RoyaltyChecksController < ApplicationController
  filter_access_to :all

  def index
    @royalty_checks = current_user.royalty_checks.all
  end
end