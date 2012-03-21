require File.dirname(__FILE__) + '/../spec_helper'

describe "linking multiple identities" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end

  it "should only link an account once" do
    page.should have_content 'google user'
    page.should have_content 'Welcome aboard!'
    visit "/users/current"
    click_link 'google_sign_in'
    page.should have_content 'Already linked that account'
  end

  it "should be able to link multiple accounts" do
    page.should have_content 'google user'
    page.should have_content 'Welcome aboard!'
    visit "/users/current"
    click_link 'facebook_sign_in'
    page.should have_content 'Successfully linked that account'
  end

  it "should have some tips to look at" do
    click_link 'tips'
    page.should have_content 'Tips'
  end

  it "should be able to change tip rate" do
    click_link 'google user'
    find_field('user[tip_preference_in_cents]').value.should == '50'
    page.select '$1.00', :from => 'user[tip_preference_in_cents]'
    click_link 'google user'
    find_field('user[tip_preference_in_cents]').value.should == '100'
  end

end