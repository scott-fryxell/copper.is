require File.dirname(__FILE__) + '/../spec_helper'

describe "signing in" do

  it "should have access to a signin link" do
    visit "/"
    page.should have_content 'Sign In With'
    page.has_selector? "body > header > hgroup > nav > a[href='/auth/twitter']"
  end

  it "should be able to login via facebook" do
    visit "/"
    page.has_selector? "body > header > hgroup > nav > a[href='/auth/facebook']"
  end

  it "should be able to login via Google" do
    visit "/"
    page.has_selector? "body > header > hgroup > nav > a[href='/auth/google']"
  end

  it "should login with twitter", :focus => true do
    visit "/"
    click_link 'twitter_sign_in'
    page.should have_content 'twitter user'
    page.should have_content 'Welcome aboard!'
  end

  it "should login with facebook" do
    visit "/"
    click_link 'facebook_sign_in'
    page.should have_content 'facebook user'
    page.should have_content 'Welcome aboard!'
  end

  it "should login with google" do
    visit "/"
    click_link 'google_sign_in'
    page.should have_content 'google user'
    page.should have_content 'Welcome aboard!'
  end

end