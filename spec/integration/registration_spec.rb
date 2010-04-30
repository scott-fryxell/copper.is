require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest registration" do
  it "should display a registration form when the guest visits the registration url" do
    visit "/"
    click_link "Sign up"
    response.should contain("Sign up for an account")
    
  end
end