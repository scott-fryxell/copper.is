require File.dirname(__FILE__) + '/../spec_helper'

describe "Fan account" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end

  it "should have some tips to look at" do
    click_link 'fan'
    click_link 'tips'
    page.should have_content 'Tips'
  end

  it "should be able to load the tip iframe javascript" do
    visit "/tips/embed_iframe.js"
  end
  
  it "should be able to change tip rate" do
    click_link 'fan'
    click_link 'tips'
    find_field('user[tip_preference_in_cents]').value.should == '50'
    page.select '$1.00', :from => 'user[tip_preference_in_cents]'
    click_link 'fan'
    click_link 'tips'
    find_field('user[tip_preference_in_cents]').value.should == '100'
  end

end