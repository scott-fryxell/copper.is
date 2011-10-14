require File.dirname(__FILE__) + '/../spec_helper'

describe "Fan" do
  describe "account page" do
    before(:each) do
      visit "/"
      click_link 'twitter_sign_in'
    end
    it "should have an account section" do
      click_link "tips"
      page.should have_selector "body > section > header > aside"
    end
    it "should display the current user's name on the page" do
      page.should have_content "twitter_fan"
    end
    it "should link to a sign out action" do
      click_link "signout"
      page.should have_content "Signed out"
    end
    it "should display the current value of each tip" do
      page.should have_content "$0.25"
    end
  end

  describe "tips page" do
    before(:each) do
      visit "/"
      click_link 'twitter_sign_in'
      click_link 'tips'
    end
    it "should include a visually offset area into which page URLs can be pasted" do
      page.should have_selector "body > section > header > form"
    end
    it "should be able to tip a page" do
      fill_in "uri", :with => "http://www.google.com"
      click_button "IOU"
      page.should have_selector "body > section > table > tbody > tr > td", :content => "http://www.google.com/"
    end
    it "should thank users when a tip is successfully given" do
      fill_in "uri", :with => "http://www.google.com"
      click_button "IOU"
      page.should have_content "Tip successfully created."
    end
    it "should not allow a URL without a host to be tipped" do
      fill_in "uri", :with => "foobar"
      click_button "IOU"
      page.should have_content "Tip is not a valid URL."
    end
    it "should link to a tip page for a fan" do
      page.should have_content "Paste a Tip"
    end
    it "should display the number of current tips" do
      page.should have_content "Tips"
    end
  end

end