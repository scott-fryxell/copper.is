require File.dirname(__FILE__) + '/../spec_helper'

describe "Users" do
  fixtures :users, :roles_users

  describe "account settings" do
    before(:each) do
      visit "/"
      click_link "Sign in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
      click_link "Settings"
    end

    it "should have a page to manage account settings" do
      response_body.should contain("Account Settings")
    end

    it "should allow the user to change their username and email and password" do
      assert_have_selector "input", :id => 'user_name'
      assert_have_selector "input", :id => 'user_email'
      assert_have_selector "input", :id => 'current_password'
      assert_have_selector "input", :id => 'password'
      assert_have_selector "input", :id => 'password_confirmation'
    end

    describe "changing user name" do
      it "should display a success message when a user changes their name" do
        fill_in "user_name", :with => "Christiano Ronaldo"
        click_button "Save"
        response_body.should contain("Your account has been updated.")
      end
    end

    describe "changing email address" do
      it "should display a message to confirm the new email when a user provides a new email" do
        fill_in "user_email", :with => "newemail@test.com"
        click_button "Save"
        response_body.should contain("Check your email (newemail@test.com) to confirm your new address. Until then, notifications will continue to be sent to your current email address.")
      end
      
      it "should display a success message when the user clicks the new email confirmation link" do
        fill_in "user_email", :with => "newemail@test.com"
        click_button "Save"
        @user = User.find_by_email('test@test.com')
        visit "/confirm_new_email/#{@user.new_email_token}"
        response_body.should contain("Your email has been changed.")
      end
      
      it "should not allow the user to confirm the new email if they are not logged in" do
        fill_in "user_email", :with => "newemail@test.com"
        click_button "Save"
        @user = User.find_by_email('test@test.com')
        visit "/logout"
        visit "/confirm_new_email/#{@user.new_email_token}"
        response_body.should contain("PERMISSION DENIED")
      end
      
      it "should not allow the user to confirm the new email of other users" do
        fill_in "user_email", :with => "newemail@test.com"
        click_button "Save"
        @user = User.find_by_email('test@test.com')
        visit "/logout"
        click_link "Sign in or sign up"
        fill_in "email", :with => "patron@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
        response_body.should contain("Successfully logged in.")
        visit "/confirm_new_email/#{@user.new_email_token}"
        response_body.should contain("There was a problem updating your email address. Please check your account settings.")
      end
      
      it "should display an error when the user enters a bad address" do
        fill_in "user_email", :with => "badaddress"
        click_button "Save"
        response_body.should contain("You must use a valid email address.")
      end
    end

    describe "managing password" do

      it "should link to a page allowing the user to change their password" do
        response_body.should contain("Change your password")
      end

      it "should display a success message when a user changes their password successfully" do
        fill_in "current_password", :with => "test"
        fill_in "password", :with => "newpass"
        fill_in "password_confirmation", :with => "newpass"
        click_button "Change password"
        response_body.should contain("Your password has been changed.")
      end

      it "should display an error when the password is too short" do
        fill_in "current_password", :with => "test"
        fill_in "password", :with => "12"
        fill_in "password_confirmation", :with => "12"
        click_button "Change password"
        response_body.should contain("Password must be at least 4 characters long")
      end

      it "should display an error when the passwords don't match" do
        fill_in "current_password", :with => "test"
        fill_in "password", :with => "onething"
        fill_in "password_confirmation", :with => "another"
        click_button "Change password"
        response_body.should contain("Passwords did not match.")
      end

      it "should display an error message when the passwords are blank" do
        fill_in "current_password", :with => "test"
        click_button "Change password"
        response_body.should contain("Password must be at least 4 characters long")
      end

      it "should display an error when the password is blank and the confirm password is valid" do
        fill_in "current_password", :with => "test"
        fill_in "password", :with => ""
        fill_in "password_confirmation", :with => "test"
        click_button "Change password"
        response_body.should contain("Password must be at least 4 characters long")
      end

      it "should display an error when the old password doesn't match current password" do
        fill_in "current_password", :with => ""
        fill_in "password", :with => "test"
        fill_in "password_confirmation", :with => "test"
        click_button "Change password"
        response_body.should contain("The current password is incorrect")
      end
    end
  end

  describe "lost password" do

    before(:each) do
      visit "/"
      click_link "Sign in or sign up"
      click_link "Forgot my password"
    end

    it "should display a form when someone has forgoton their password" do
      response_body.should contain("Please enter your email address to reset your password")
    end

    it "should display a success message when the user enters a known email address in the password reset form" do
      fill_in "email", :with => "test@test.com"
      click_button "Reset Password"
      response_body.should contain("Check for an email with instructions on resetting your password.")
    end

    it "should display an error when the user enters an unknown email address in the password reset form" do
      fill_in "email", :with => "unknown@unknown.com"
      click_button "Reset Password"
      response_body.should contain("No Weave account exists for that email address.")
    end

    it "should display an error when user tries to use an invalid token to identify themselves" do
      visit "/password/reset/123foo"
      response_body.should contain("We couldn't locate your account. Request a new token.")
    end

    describe "reset email notification" do

      before(:each) do
        ActionMailer::Base.delivery_method = :test
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []
      end

      it "should send an message with instructions on how to reset your password after submitting the form with a known email" do
        fill_in "email", :with => "test@test.com"
        click_button "Reset Password"
        ActionMailer::Base.deliveries.length.should == 1 # enhance test by adding && clause that checks content of the message that was sent
      end
    end

    it "should change the confirmed account owner's password" # this is testing the entire sequence and will be hard to write

  end

  it "should display a form when a user has forgotton what their login is" # not implementing lost username for MVP

end
