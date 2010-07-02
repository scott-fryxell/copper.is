class AdminUserReportsController < ApplicationController
  
  filter_access_to :active
  
  def active
    @users = User.find_active_users
  end
  
end