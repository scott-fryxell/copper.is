require File.dirname(__FILE__) + '/../spec_helper'

describe "tipping a page", :slow do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    visit "/test"
    ResqueSpec.reset!
    ResqueSpec.inline = false
    
  end

  after(:each) do
    page.driver.error_messages.size.should == 0
    ResqueSpec.reset!
    ResqueSpec.inline = true
  end

  it "should display the tipped pages title" do
    page.should have_selector('#copper')
    within_frame('copper') do
      page.execute_script("jQuery.fx.off = true")
      page.should have_content("copper-test page")
      page.should have_content("0.25")
    end
    User.first.tips.count.should == 1
  end

  it "should be able to update a tip"
end
