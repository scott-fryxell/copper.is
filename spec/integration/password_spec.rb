require File.dirname(__FILE__) + '/../spec_helper'

describe "Password" do
  fixtures :roles_users, :users

  describe "lost management" do

    before(:each) do
      visit "/"
      click_link "Log in or sign up"
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

    it "should display an error message when the user enters an unknown email address in the password reset form" do
      fill_in "email", :with => "unknown@unknown.com"
      click_button "Reset Password"
      response_body.should contain("No Weave account exists for that email address.")
    end

    it "should display an error message when user tries to use an invalid token to identify themselves" do
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

  describe "change management" do
    it "should display a success message when a user changes their password successfully"
    it "should display a form when a user has forgotton what their login is" # not implementing lost username for MVP
  end
end
