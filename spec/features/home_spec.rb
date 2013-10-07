require File.dirname(__FILE__) + '/../spec_helper'

describe "A guest", :slow do
  before(:each) do
    mock_user
    visit "/"
  end

  it "will see the welcome page when they first visit copper" do
    # page.response_code.should be(200) :broken
    page.should have_content('Support your favorite artists and easily discover new ones');
    page.save_screenshot('tmp/screenshots/welcome.png')
  end

  it "can not see the fan navigation" do
    page.should have_css('#fan_nav', visible:false)
    page.should have_css('#admin_nav', visible:false)
    page.should have_css('#guest_nav', visible:false)
    page.should have_css('a[href="/auth/facebook"]', visible:true)
    page.should have_css('a[href="/getting_started"]', visible:true)
  end

  it 'sign out and back in' do
    click_link 'Sign in'
    page.should have_css('#fan_nav', visible:true)
    page.should have_css('#guest_nav', visible:false)
    page.should have_css('#admin_nav', visible:false)
    page.should have_css('a[href="/author"]', visible:true)
    page.should have_css('a[href="/settings"]', visible:true)
    page.should have_css('a[href="/signout"]', visible:true)
    click_link 'Sign out of Copper'
  end

end
