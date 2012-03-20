require File.dirname(__FILE__) + '/../spec_helper'

describe "linking multiple identities" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end
  
  it "should only link an account once multiple accounts" do
    page.should have_content 'google user'
    page.should have_content 'Welcome aboard!'

    visit "/users/current"
    click_link 'google_sign_in'
    page.should have_content 'Already linked that account'

  end

  it "should have some tips to look at" do
    click_link 'tips'
    page.should have_content 'Tips'
  end

  it "should have information for authors " do
    click_link 'authors'
    page.should have_content 'Authors, use the badge on your site'
  end

  it "should have a place to install a browser extension " do
    click_link 'button'
    page.should have_content 'Install the Tip button'
    page.should have_content 'Firefox'
    page.should have_content 'Chrome'
    page.should have_content 'Safari'
  end

  it  "should be able to log a fan out" do
    click_link 'signout'
    page.should have_content 'Signed out'
  end

end