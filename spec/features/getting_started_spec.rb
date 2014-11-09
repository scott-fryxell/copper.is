require 'spec_helper'

describe "A guest", :slow, :type => :feature do
  before(:each) do
    visit "/getting_started"
  end

  it "can view a general description of how to get started" do
    expect(page).to have_css('section#step_one', visible:true)
    expect(page).to have_css('section#step_two', visible:true)
    expect(page).to have_css('section#step_three', visible:true)
  end

  it "can see instructions for any browser" do
    page.execute_script('$("#home_getting_started > section").addClass("chrome")')
    expect(page).to have_css('.safari', visible:false)
    expect(page).to have_css('.chrome', visible:true)
    expect(page).to have_css('.firefox', visible:false)
    page.save_screenshot('tmp/screenshots/getting_started/chrome.png')
  end

  it "can see instructions for safari" do
    page.execute_script('$("#home_getting_started > section").addClass("safari")')
    expect(page).to have_css('.safari', visible:true)
    expect(page).to have_css('.chrome', visible:false)
    expect(page).to have_css('.firefox', visible:false)
    page.save_screenshot('tmp/screenshots/getting_started/safari.png')
  end

  it "can see instructions for firefox" do
    page.execute_script('$("#home_getting_started > section").addClass("firefox")')
    expect(page).to have_css('.safari', visible:false)
    expect(page).to have_css('.chrome', visible:false)
    expect(page).to have_css('.firefox', visible:true)
    page.save_screenshot('tmp/screenshots/getting_started/firefox.png')
  end
end
