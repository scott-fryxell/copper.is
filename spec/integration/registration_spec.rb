require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest registration" do
  fixtures :roles_users, :users

  it "should display a registration form when the guest visits the registration url" do
    visit "/"
    click_link "Log in or sign up"
    response_body.should contain("I need an account")
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

  it "should check to make sure the email address is not already registered for an account" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "test@test.com"
    choose "No, I need an account"
    fill_in "password", :with => "test"
    fill_in "password_confirmation", :with => "test"
    click_button "Log in"
    response_body.should contain("There is already a Weave account for that email address.")
  end

  it "should validate that the email address is valid" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "testtest"
    choose "No, I need an account"
    fill_in "password", :with => "test"
    fill_in "password_confirmation", :with => "test"
    click_button "Log in"
    response_body.should contain("You must sign up with a valid email address.")
  end

  it "should require a new user to confirm their password" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "confirmme@test.com"
    choose "No, I need an account"
    fill_in "password", :with => "test"
    fill_in "password_confirmation", :with => ""
    click_button "Log in"
    response_body.should contain("Passwords did not match.")
  end

  it "should require that passwords be at least 4 characters long" do
    visit "/"
    click_link "Log in or sign up"
    fill_in "email", :with => "confirmme@test.com"
    choose "No, I need an account"
    fill_in "password", :with => "tes"
    fill_in "password_confirmation", :with => "tes"
    click_button "Log in"
    response_body.should contain("Password must be at least 4 characters long")
  end
end
