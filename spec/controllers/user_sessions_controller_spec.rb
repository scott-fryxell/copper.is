require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  describe "when logging in with valid credentials" do
    fixtures :users, :roles_users

    before :each do
      post :create, :email => "test@test.com", :password => "test", :registered => "yes"
    end

    it "should redirect to another page" do
      response.should be_redirect
    end

    it "should return a message indicating success upon successful login" do
      flash[:notice].should contain("Successfully logged in")
    end

    it "should redirect the user to the main page" do
      response.should redirect_to(root_url)
    end
  end
end