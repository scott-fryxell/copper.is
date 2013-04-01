require File.dirname(__FILE__) + '/../spec_helper'

describe "A guest", :slow do
  before(:each) do
    mock_user
    visit "/"
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "will see the welcome page when they first visit copper" do
    page.should have_content('Support Artists Through Tipping');
    page.save_screenshot('tmp/screenshots/welcome.png')
  end

  it "can not see the fan navigation" do
    page.should have_css('#user_nav', visible:false)
    page.should have_no_css('a[href="/signout"]', visible:true)
    page.should have_css('#join', visible:true)
    click_link 'connect with facebook'
    page.should have_css('#user_nav', visible:false)
    page.should have_css('a[href="/signout"]', visible:true)
  end

  it 'sign out and back in' do
    click_link 'connect with facebook'
    click_link 'Sign out of Copper'
    click_link 'connect with facebook'
  end

end
