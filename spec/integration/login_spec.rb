require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest login" do
  fixtures :roles_users, :users

  before(:each) do
    visit "/"
    click_link "Log in or sign up"
  end

  describe "with valid email" do

    before(:each) do
      fill_in "email", :with => "test@test.com"
    end

    it "should display a success message when a Guest logs in with a known email address and correct password" do
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
      response_body.should contain("Successfully logged in.")
    end

    it "should display a failure message on the login page when a Guest tries to log in with a known email address but incorrect password" do
      fill_in "password", :with => "wrong"
      choose "Yes, I have a password:"
      click_button "Log in"
      response_body.should contain("We didn't recognize your email or password")
    end

    it "should display a failure message on the login page when a Guest tries to log in with a blank (invalid) password" do
      fill_in "password", :with => ""
      choose "Yes, I have a password:"
      click_button "Log in"
      response_body.should contain("You must enter a password")
    end

    it "should allow the user to stay logged in for 2 weeks if they want" do
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      check "Keep me logged in"
      click_button "Log in"
      response_body.should contain("Successfully logged in.")
    end

  end

  describe "with unknown email" do

    before(:each) do
      fill_in "email", :with => "unknown@test.com"
    end

    it "should display a failure message on the login page when a Guest tries to log in with an unknown email address" do
      fill_in "password", :with => "wrong"
      choose "Yes, I have a password:"
      click_button "Log in"
      response_body.should contain("We didn't recognize your email or password")
    end

    it "should blank out the email field when the Guest fails to log in" do
      fill_in "password", :with => "wrong"
      choose "Yes, I have a password:"
      click_button "Log in"
      field_with_id('email').value.should == ""
    end

    it "should always, for security reasons, blank out the password field when the Guest fails to log in" do
      fill_in "password", :with => "wrong"
      choose "Yes, I have a password:"
      click_button "Log in"
      field_with_id('password').value.should == ""
    end

  end

  it "should link to a page to retrieve a forgotton password" do
    click_link "Forgot my password"
    response_body.should contain("Please enter your email address to reset your password")
  end

end