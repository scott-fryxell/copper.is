require File.dirname(__FILE__) + '/../spec_helper'

describe "signing in" do
  fixtures :users, :roles_users

  it "should have access to a signin link" do
    visit "/"
    page.should have_content 'Sign In' 

  end

  it "should be able to login via twitter" do
    visit "/"
    page.has_selector? "body > header > hgroup > nav > a[href='/auth/twitter']"
  end

  it "should be able to login via facebook" do
    visit "/"
    page.has_selector? "body > header > hgroup > nav > a[href='/auth/facebook']"
  end

end