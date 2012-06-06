require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan's account settings", :broken do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
    click_link 'Account settings'
    page.execute_script("$.fx.off")
  end

  it "should be able to query items on the page" do
    page.evaluate_script("document.getItems().length").should equal(1)
  end

  it "should be able to query for user" do
    page.evaluate_script("document.getItems('users').length").should equal(1)
  end

  it "should be able to query for user email" do
    page.evaluate_script("document.getItems().users[0].email").should == "user@google.com"
  end

  it "should be able to change user email from the command line" do
    page.execute_script("document.getItems().users[0].email = 'change@google.com'")
    page.execute_script("document.getItems().users[0].save()")
    find("div > p").should have_content("change@google.com")
    find_field('email').value.should == 'change@google.com'
  end

  it "should be able to change email" do
    within("section#email") do
      find("div > p").should have_content("user@google.com")
      click_link "Change"
      find_field('email').value.should == 'user@google.com'
      fill_in('email', :with => 'change@google.com')
      click_on 'Save'
      find("div > p").should have_content("change@google.com")
    end

  end
end
