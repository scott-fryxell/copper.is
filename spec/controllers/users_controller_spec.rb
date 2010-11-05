require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe UsersController do
  fixtures :users, :roles_users
  setup :activate_authlogic

  before :each do
    @session = UserSession.new(users(:active))
    @session.save
  end

  describe "update password" do

    describe "with valid current password" do
      before :each do
        put :update_password, :user => {:current_password => "test", :password => "newone" , :password_confirmation => "newone"}
      end

      it "should return a message indicating success" do
        flash[:notice].should contain("Your password has been changed.")
      end

      it "should display the account page" do
        response.should render_template('edit')
      end
    end

    describe "with invalid current password" do
      before :each do
        put :update_password, :user => {:current_password => "", :password => "newone" , :password_confirmation => "newone"}
      end

      it "should return a message indicating failure" do
        flash[:notice].should contain("The current password is incorrect.")
      end

      it "should display the account page" do
        response.should render_template('edit')
      end
    end

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

  describe "changing email" do
    describe "with a new and valid email" do
      before :each do
        put :update_user, :user => {:email => "newemail@test.com"}
        @user = User.find(@session.record.id)
      end

      it "should display a message that the new email must be verified" do
        flash[:notice].should contain("Check your email (newemail@test.com) to confirm your new address. Until then, notifications will continue to be sent to your current email address.")
      end

      it "should send an email to the new address requesting confirmation" do
        Notifier.should_receive(:deliver_email_change_confirm)
        put :update_user, :user => {:email => "newemail@test.com"}
      end

      it "should send an email to the current address notifying of the change" do
        Notifier.should_receive(:deliver_email_change_notify)
        put :update_user, :user => {:email => "newemail@test.com"}
      end

      it "should store the new email address in the new_email field" do
        @user.new_email.should == "newemail@test.com"
      end

      it "should store the current address in the email field" do
        @user.email.should == "test@test.com"
      end

      it "should move the new email to the email field after the user clicks the link in the confirm email" do
        post :confirm_new_email, :id => @user.new_email_token
        @user = User.find(@user.id)
        @user.email.should == "newemail@test.com"
        @user.new_email.should == nil
      end

      it "should display a success message when the user follows the confirmation link" do
        post :confirm_new_email, :id => @user.new_email_token
        flash[:notice].should contain("Your email has been changed.")
      end
    end

    describe "with the same email" do
      it "should not update the email" do
        @user = User.find(@session.record.id)
        put :update_user, :user => {:email => "test@test.com"}
        flash[:notice].should contain("Your account has been updated.")
        @user = User.find(@user.id)
        @user.email.should == "test@test.com"
        @user.new_email.should be_nil
        @user.new_email_token.should be_nil
      end
    end

    describe "with an email already in use by another user" do
      before :each do
        put :update_user, :user => {:email => "admin@test.com"}
        @user = User.find(@session.record.id)
      end

      it "should display a failure message when the user tries to confirm that email address" do
        post :confirm_new_email, :id => @user.new_email_token
        flash[:notice].should contain("There was a problem updating your email address. Please check your account settings.")
      end
    end

    describe "with an invalid email" do
      before :each do
        put :update_user, :user => {:email => "badaddress"}
      end

      it "should return an error message" do
        flash[:notice].should contain("You must use a valid email address.")
      end

      it "should display a failure message if the user tries to update the email through the confirmation link" do
        @user = User.find_by_email('test@test.com')
        post :confirm_new_email, :id => @user.new_email_token
        flash[:notice].should contain("There was a problem updating your email address. Please check your account settings.")
      end
    end
  end

end