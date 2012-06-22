require File.dirname(__FILE__) + '/../spec_helper'

describe "tipping a page" do
  before(:each) do
    DatabaseCleaner.clean
    visit "/"
    click_link 'facebook_sign_in'
    visit "/test"
  end

  it "should embed the copper iframe" do
    page.should have_selector('#copper')
  end

  it "should display the tipped pages title" do pending
    within_frame('copper') do
      page.execute_script("$.fx.off")
      page.should have_content("copper-test page")
      page.should have_content("0.25")
    end
  end
end