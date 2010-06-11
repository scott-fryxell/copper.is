require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest registration" do
  it "should display a registration form when the guest visits the registration url" do
    visit "/"
    click_link "Log in or sign up"
    response_body.should contain("I need an account")
  end
end

describe "Guest login" do
  fixtures :roles_users, :users

  it "should display a success message when a Guest logs in with a known email address and correct password" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "test@test.com"
    fill_in "password", :with => "test"
    choose "Yes, I have a password:"
    click_button
    response_body.should contain("Successfully logged in.")
  end

  it "should display a failure message on the login page when a Guest tries to log in with an unknown email address" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "unknown@test.com"
    fill_in "password", :with => "wrong"
    choose "Yes, I have a password:"
    click_button "Log in"
    response_body.should contain("We didn't recognize your email or password")
  end

  it "should display a failure message on the login page when a Guest tries to log in with a known email address but incorrect password" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "test@test.com"
    fill_in "password", :with => "wrong"
    choose "Yes, I have a password:"
    click_button "Log in"
    response_body.should contain("We didn't recognize your email or password")
  end

  it "should display a failure message on the login page when a Guest tries to log in with a blank (invalid) password" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "test@test.com"
    fill_in "password", :with => ""
    choose "Yes, I have a password:"
    click_button "Log in"
    response_body.should contain("We didn't recognize your email or password")
  end

  it "should blank out the email field when the Guest fails to log in" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "unknown@test.com"
    fill_in "password", :with => "wrong"
    choose "Yes, I have a password:"
    click_button "Log in"
    field_with_id('email').value.should == ""
  end

  it "should always, for security reasons, blank out the password field when the Guest fails to log in" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "unknown@test.com"
    fill_in "password", :with => "wrong"
    choose "Yes, I have a password:"
    click_button "Log in"
    field_with_id('password').value.should == ""
  end

  it "should allow a guest to register for an account" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "newguy@newguy.com"
    choose "No, I need an account"
    fill_in "password", :with => "thepassword"
    fill_in "password_confirmation", :with => "thepassword"
    click_button "Log in"
    response_body.should contain("Registration successful.")
  end
  
  it "should check to make sure user is not already registered for an account"
  it "should link to a page to retrieve a forgotton password"
  it "should allow the user to stay logged in for 2 weeks if they want"
  it "should validate that the email address is valid"
  it "should require a new user to confirm their password"
  it "should change the login button to 'Create account' when creating a new account"
end