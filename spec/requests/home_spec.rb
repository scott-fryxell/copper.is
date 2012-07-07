require File.dirname(__FILE__) + '/../spec_helper'

describe "home page experience",:broken do
  before(:each) do
    DatabaseCleaner.clean
    visit "/"
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should display the signin ui" do
    page.should have_css('#sign_in', visible:true)
    page.should have_css('#signed_in', visible:false)
    page.should have_no_css('a[href="/signout"]', visible:true)
    page.should have_css('#signin_with_fb', visible:true)
    click_link 'facebook_sign_in'
    page.should have_css('#sign_in', visible:false)
    page.should have_css('#signed_in', visible:true)
    page.should have_css('a[href="/signout"]', visible:true)
  end

  it "should show the welcome message after user signs in" do
    page.should have_css('#welcome', visible:false)
    page.should have_no_css('#congrats', visible:true)
    page.should have_no_css('#facebook', visible:true)
    page.should have_no_css('section.settings', visible:true)
    click_link 'facebook_sign_in'
    page.should have_no_css('#signin_with_fb', visible:true)
    page.should have_css('#welcome', visible:true)
    page.should have_css('#congrats', visible:false)
  end

  it "should show the congrats message after the user installs the button", :focus do
    click_on('connect with facebook')
    page.execute_script("jQuery.fx.off = true")
    page.should have_css('#welcome', visible:true)

    # simulating the event the extension will trigger when installed
    page.execute_script('$(document).trigger("copper:button_installed")')

    page.should have_no_css('#welcome', visible:true)
    page.should have_css('#congrats', visible:true)
    page.should have_css('#facebook', visible:true)
    page.should have_css('.settings', count:2, visible:true)

  end

  it "should carosel the sample images"

  it "should let the user sign in with facebook link on connect section"

  it "should show the users recent activity"
end
