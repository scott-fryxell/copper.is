require File.dirname(__FILE__) + '/../spec_helper'

describe "a guest who wants to learn how to get started with copper",:focus, :slow do
  before(:each) do
    visit "/getting_started"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "can view a general description of how to get started" do
    page.should have_css('figure#any_url', visible:true)
    page.should have_css('figure#sign_up_install_button', visible:true)
    page.should have_css('figure#start_tipping', visible:true)
  end

  it "can see instructions for any browser" do
    page.execute_script('$("#home_getting_started > section").addClass("chrome")')
    page.should have_css('.safari', visible:false)
    page.should have_css('.chrome', visible:true)
    page.should have_css('.firefox', visible:false)
    page.save_screenshot('tmp/screenshots/getting_started/chrome.png')
  end

  it "can see instructions for safari" do
    page.execute_script('$("#home_getting_started > section").addClass("safari")')
    page.should have_css('.safari', visible:true)
    page.should have_css('.chrome', visible:false)
    page.should have_css('.firefox', visible:false)
    page.save_screenshot('tmp/screenshots/getting_started/safari.png')
  end

  it "can see instructions for firefox" do
    page.execute_script('$("#home_getting_started > section").addClass("firefox")')
    page.should have_css('.safari', visible:false)
    page.should have_css('.chrome', visible:false)
    page.should have_css('.firefox', visible:true)
    page.save_screenshot('tmp/screenshots/getting_started/firefox.png')
  end
end
