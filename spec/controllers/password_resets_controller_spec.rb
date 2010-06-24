require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  describe "Password reset" do
    fixtures :users, :roles_users

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    describe "requests" do

      describe "when email address is known" do

        before(:each) do
          post :create, :email => "test@test.com"
        end

        it "should return a message indicating success" do
          flash[:notice].should contain("Check for an email with instructions on resetting your password.")
        end

        it "should send an email with instructions on reseting your password" do
          ActionMailer::Base.deliveries.length.should == 1 # enhance test by adding && clause that checks content of the message that was sent
        end

      end

      describe "when email address is not known" do

        it "should display an error message" do
          post :create, :email => "unknown@test.com"
          flash[:notice].should contain("No Weave account exists for that email address.")
        end

      end

    end

    describe "submissions" do

      before(:each) do
        @user = users(:email1)
      end

      it "should display a success message when the password is valid" do
        post :update, :id => @user.perishable_token, :user => {:password_confirmation => "test", :password => "test"}
        flash[:notice].should contain("Your password has been changed.")
      end

      it "should display an error when the password is too short" do
        post :update, :id => @user.perishable_token, :user => {:password_confirmation => "12", :password => "12"}
        flash[:notice].should contain("Password must be at least 4 characters long")
      end

      it "should display an error when the passwords don't match" do
        post :update, :id => @user.perishable_token, :user => {:password_confirmation => "this", :password => "that"}
        flash[:notice].should contain("Passwords did not match.")
      end

      it "should display an error when the password is empty" do
        post :update, :id => @user.perishable_token, :user => {:password_confirmation => "", :password => ""}
        flash[:notice].should contain("Password must be at least 4 characters long")
      end

    end

  end

end