require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest registration" do
  it "should display a registration form when the guest visits the registration url" do
    visit "/"
    click_link "Log in or sign up"
    response_body.should contain("I need an account")
  end
end

describe "Guest login" do
  fixtures :users, :roles_users

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
end