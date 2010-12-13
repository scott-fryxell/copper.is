require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe UsersController do
  fixtures :users, :roles_users
  setup :activate_authlogic

  before :each do
    @session = UserSession.new(users(:active))
    @session.save
  end


  describe "update user name" do
    describe "with valid user name" do
      before :each do
        put :update_user, :user => {:user_name => "spider", :email => "test@test.com"}
      end

      it "should return a message indicating success" do
        flash[:notice].should contain("Your account has been updated.")
      end
    end
  end


end