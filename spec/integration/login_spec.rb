require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Guest login" do
  it "should succeed when Guest provides proper credentials" do     
      visit "/"
      click_link "login"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      click_button "Login"
  end
  
end