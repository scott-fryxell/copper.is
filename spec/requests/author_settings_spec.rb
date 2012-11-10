require File.dirname(__FILE__) + '/../spec_helper'

describe "a authors's settings page", :slow do
  before :each  do
  visit '/'
  click_link 'facebook_sign_in'
  visit "/authors/me/edit"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it 'should be able to authorize facebook', :focus do
    within '#identities figure.facebook > figcaption' do
      page.should have_content('facebook.user');
    end

    within '#identities' do
      click_link 'Add/Remove'
      page.should have_css('figure.facebook figcaption', visible:true)
      page.should have_css('aside', visible:true)
    end
  end

  it "should be able to authorize multible services"
  it "should be able to deauthorize services"
  
  it "should always have at least one service authorized"
  it 'should be able to change their email'
  it 'should be able to change their address'
end
