class ChecksController < ApplicationController
  filter_access_to :all

  def index
    @checks = current_user.checks.all
  end
end