require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan's account settings",:pending do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
    click_link 'Account settings'
    page.execute_script("$.fx.off")
  end

  it "should be able to query items on the page" do
    page.evaluate_script("document.getItems().users.length").should equal(1)
  end

  it "should be able to query for user email" do
    page.evaluate_script("document.getItems().users[0].props.email").should == "user@google.com"
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

  it "should be able to change email", :focus do
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
