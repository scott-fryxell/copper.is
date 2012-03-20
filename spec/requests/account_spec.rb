require File.dirname(__FILE__) + '/../spec_helper'

describe "linking multiple identities" do
  it "should be able to link multiple accounts" do
    visit "/"
    click_link 'google_sign_in'
    page.should have_content 'google user'
    page.should have_content 'Welcome aboard!'


    visit "/users/current"
    click_link 'google_sign_in'
    page.should have_content 'Already linked that account'

  end


end