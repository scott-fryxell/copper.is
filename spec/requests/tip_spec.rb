require File.dirname(__FILE__) + '/../spec_helper'

describe "tipping a page" do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    visit "/test"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should embed the copper iframe" do
    page.should have_selector('#copper')
  end

  it "should display the tipped pages title" do
    within_frame('copper') do
      page.execute_script("jQuery.fx.off = true")
      page.should have_content("copper-test page")
      page.should have_content("0.25")
    end
  end

  it "should be able to update a tip"

  it "should confirm that tip was created"
end
