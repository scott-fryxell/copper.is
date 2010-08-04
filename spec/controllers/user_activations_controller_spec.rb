require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserActivationsController do
  fixtures :users, :roles_users

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  describe "when requesting activivation" do
    describe "when user is inactive" do
      before(:each) do
        post :send_activation, :email => "notactive@test.com"
      end

      it "should return a message indicating a success when activation is requested" do
        flash[:notice].should contain("Please check your email for instructions on activating your account.")
      end

      it "should send an email with activation instructions" do
        ActionMailer::Base.deliveries.length.should == 1 # TODO enhance test by adding && clause that checks content of the message that was sent
      end
    end

    describe "when user is already active" do
      before(:each) do
        post :send_activation, :email => "test@test.com"
      end

      it "should return a message indicating the account is already active" do
        flash[:notice].should contain("Your account is already active. Please login.")
      end

      it "should redirect the user to the login page" do
        response.should redirect_to(login_url)
      end
    end

    describe "when user is unknown" do
      before(:each) do
        post :send_activation, :email => "unknown@test.com"
      end

      it "should return a message stating that the email is unknown" do
        flash[:notice].should contain("No Weave account exists for that email address.")
      end
    end
  end

  describe "when attempting activation" do
    describe "with valid token" do
      before(:each) do
        @user = users(:inactive)
        post :activate, :id => @user.perishable_token
      end

      it "should allow user to activate the account when perishable token is valid" do
        @activated_user = User.find_by_email(@user.email)
        @activated_user.active.should be_true
      end

      it "should display a message indicating successful activation" do
        flash[:notice].should contain("Your account has been activated.")
      end

      it "should display a welcome page" do
        response.should redirect_to('bookmarklet')
      end

      it "should automatically log the user in" do
        @current_user_session = UserSession.find
        @current_user_session.should_not be_nil
      end

      it "should send a welcome email after the account is activated" do
        ActionMailer::Base.deliveries.length.should == 1
      end

      it "should set the activation date" do
        @activated_user = User.find_by_email(@user.email)
        @activated_user.activation_date.should be_close(Time.now, 20)
      end
    end

    describe "with invalid token" do
      before(:each) do
        post :activate, :id => "123badtoken"
      end

      it "should redirect to a page for requesting a new token when the perishable token is not valid" do
        flash[:notice].should contain("We couldn't activate your account. Enter your email address to get an activation email.")
      end
    end
  end
end
