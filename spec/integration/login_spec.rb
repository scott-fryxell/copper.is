require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest login" do
  
  it "should display a success message when a Guest logs in with a known email address and correct password" do
    visit "/"
    click_link "Login"
    fill_in "email", :with => "test@test.com"
    fill_in "password", :with => "test"
    click_button "Login"
    response.should contain("Successfully logged in.")
  end

  it "should display a failure page when a Guest tries to log in with an unknown email address"
  it "should display a failure page when a Guest tries to log in without registering first"
  it "should display a failure page when a Guest tries to log in with a known email address but incorrect password"
  it "should display a failure page when a Guest tries to log in with a blank (invalid) password"
  it "should provide a link to the registration when the Guest fails to log in"
  it "should blank out the username field when the Guest fails to log in"
  it "should always, for security reasons, blank out the password field when the Guest fails to log in"
end