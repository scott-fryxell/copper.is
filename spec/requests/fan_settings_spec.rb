require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan's account settings" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end

  it "should be able to change email", :focus do
    click_link 'Account settings'
    find("section#email > div > p").should have_content("user@google.com")

    within("section#email") do
      click_link "Change"
      find("form")
      # find_field('user[email]').value.should == 'user@google.com'
      # fill_in('user[email]', :with => 'change@google.com')
      # click_on 'Save'
    end
    # click_link 'Account settings'
    # find_field('user[email]').value.should == 'change@google.com'
  end
end
