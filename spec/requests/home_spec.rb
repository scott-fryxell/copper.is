require File.dirname(__FILE__) + '/../spec_helper'

describe "home page experience", :slow, :focus do
  before(:each) do
    visit "/"
    page.execute_script("jQuery.fx.off = true")
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should display fan profile for logged in users"

  it "should display the signin ui" do
    page.should have_css('#sign_in', visible:true)
    page.should have_css('#signed_in', visible:false)
    page.should have_no_css('a[href="/signout"]', visible:true)
    page.should have_css('#join', visible:true)
    click_link 'facebook_sign_in'
    page.execute_script("jQuery.fx.off = true")
    page.should have_css('#sign_in', visible:false)
    page.should have_css('#signed_in', visible:true)
    page.should have_css('a[href="/signout"]', visible:true)
  end

  it "should show the welcome message after user signs in" do
    page.should have_css('#join', visible:true)
    page.should have_css('figure.step_one', visible:true)
    page.should have_no_css('figure.step_two', visible:true)
    page.should have_no_css('#congrats', visible:true)
    page.should have_no_css('#facebook', visible:true)
    page.should have_no_css('section.settings', visible:true)
    click_link 'facebook_sign_in'
    page.execute_script("jQuery.fx.off = true")
    page.should have_css('#join', visible:true)
    page.should have_css('figure.step_two', visible:true)
    page.should have_no_css('figure.step_one', visible:true)
    page.should have_no_css('#welcome', visible:true)
    page.should have_no_css('#congrats', visible:true)
  end

  it "should show the congrats message after the user installs the button" do
    click_on('connect with facebook')
    page.execute_script("jQuery.fx.off = true")
    page.should have_css('#join', visible:true)
    # simulating the event the extension will trigger when installed
    page.execute_script('$(document).trigger("copper_button_installed")')
    page.should have_css('#join', visible:false)
    page.should have_css('#congrats', visible:true)
    page.should have_css('#facebook', visible:true)
    page.should have_css('#settings', visible:true)
  end


  it 'should be able to sign out and back in' do
    click_link 'facebook_sign_in'
    click_link 'Sign Out'
    click_link 'facebook_sign_in'
  end

end
