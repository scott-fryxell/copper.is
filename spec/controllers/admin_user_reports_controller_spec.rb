require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe AdminUserReportsController do
  fixtures :users, :roles_users
  setup :activate_authlogic

  def admin_user_session
    UserSession.create(users(:admin_user))
  end

  describe "recently added and active users report" do

    before(:each) do
      @admin = admin_user_session
    end

    before(:each) do
      get :active
    end

    it "should make the list of active users available to the view" do
      assigns['users'].size.should == 7
    end

  end

end