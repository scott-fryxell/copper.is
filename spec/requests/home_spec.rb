require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest home page experience", :slow do
  before(:each) do
    visit "/"
    page.execute_script("jQuery.fx.off = true")
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should display the user nav" do
    page.should have_css('#user_nav', visible:false)
    page.should have_no_css('a[href="/signout"]', visible:true)
    page.should have_css('#join', visible:true)
    click_link 'connect with facebook'
    page.execute_script("jQuery.fx.off = true")
    page.should have_css('#user_nav', visible:false)
    page.should have_css('a[href="/signout"]', visible:true)
  end

  it 'should be able to sign out and back in' do
    click_link 'connect with facebook'
    click_link 'Sign Out'
    click_link 'connect with facebook'
  end

end
