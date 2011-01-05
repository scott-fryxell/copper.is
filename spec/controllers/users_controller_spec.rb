require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe UsersController, :type => :controller do
  fixtures :users, :roles_users
  setup :activate_authlogic

  before :each do
    @session = UserSession.new(users(:patron))
    @session.save
  end

  describe "update user tip amount preference" do
    it "should return a message indicating success" do
      put :update, :id => users(:patron).id, :user => {:tip_preference_in_cents => "25"}
      flash[:notice].should contain("Your account has been updated.")
    end
  end

end