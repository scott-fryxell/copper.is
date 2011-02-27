require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController, :type => :controller do
  fixtures :roles, :users, :roles_users
  setup :activate_authlogic
  before :each do
    without_access_control do
      UserSession.create users(:a_fan)
    end
  end

  describe "update user tip amount preference" do
    it "should return a message indicating success" do

      without_access_control do
        put :update, :id => users(:a_fan).id, :user => {:tip_preference_in_cents => "25"}
        flash[:notice].should contain("Your account has been updated.")
      end
    end
  end

end