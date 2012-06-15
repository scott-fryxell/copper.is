require File.dirname(__FILE__) + '/../spec_helper'

describe "tipping a page" do
  before(:each) do
    DatabaseCleaner.clean
    visit "/"
    click_link 'facebook_sign_in'
    visit "/test"
    page.execute_script("$.fx.off")
  end

  it "should embed the copper iframe" do
    page.should have_css('#copper')
  end

  it "should display the tipped pages title", :focus do
    within("#copper") do
      page.should have_content("test - copper.is")
    end
  end
end