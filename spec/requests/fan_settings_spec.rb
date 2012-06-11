require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan's account settings", :broken do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    # save_and_open_page
    click_link 'Account settings'
    page.execute_script("$.fx.off")

  end

  it "should be able to query items on the page" do

    page.evaluate_script("document.getItems().users").should equal(1)
  end

  it "should be able to query for user email" do
    page.evaluate_script("user.email").should == "user@google.com"
  end

  it "should be able to change user email from the command line" do
    within("section#email") do
      find("div > p").should have_content("user@google.com")
      page.execute_script("user = document.getItems().users[0]")
      page.execute_script("user.email = 'change@google.com'")
      page.execute_script("user.inject()")
      find("div > p").should have_content("change@google.com")
      click_link "Change"
      find_field('user[email]').value.should == 'change@google.com'
    end
  end

  it "should be able to change email" do
    within("section#email") do
      find("div > p").should have_content("user@google.com")
      click_link "Change"
      find_field('user[email]').value.should == 'user@google.com'
      fill_in('email', :with => 'change@google.com')
      click_on 'Save'
      find("div > p").should have_content("change@google.com")
    end

  end
end
