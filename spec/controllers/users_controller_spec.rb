require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe UsersController do
  fixtures :users, :roles_users
  setup :activate_authlogic

  def user_session
    UserSession.create(users(:active))
  end

  describe "update" do

    describe "with valid credentials" do

      before :each do
        @user = user_session
        put :update_password, :user => {:current_password => "test", :password => "new" , :password_confirmation => "new"}
      end

      it "should return a message indicating success" do
        flash[:notice].should contain("Your password has been changed.")
      end

      it "should display the account page" do
        response.should redirect_to(accounts_url)
      end
    end

    describe "with invalid credentials" do

      before :each do
        @user = user_session
        put :update_password, :user => {:current_password => "", :password => "new" , :password_confirmation => "new"}
      end

      it "should return a message indicating failure" do
        flash[:notice].should contain("The current password is incorrect.")
      end

      it "should display the account page" do
        response.should redirect_to(accounts_url)
      end
    end

  end

end