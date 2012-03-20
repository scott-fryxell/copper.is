require File.dirname(__FILE__) + '/../spec_helper'


describe "Guest" do

  describe "every page" do
    before(:each) do
      visit "/"
    end

    it "should contain a global nav section" do
      page.has_selector? "body > header"
    end

    it "should contain a courtesy nav section" do
      page.has_selector? "body > footer"
    end

    it "should contain a content area" do
      page.has_selector? "body > section"
    end

    it "should contain a logo" do
      page.has_selector? "body > header > a"
    end
  end

  describe "global navigation" do
    before(:each) do
      visit "/"
    end

    it "should visit authors" do
      visit '/authors'
      page.should have_content 'Authors, use the badge on your site'
    end

    it "should visit button" do
      visit '/button'
      page.should have_content 'Install the Tip button'
    end

  end

  describe "footer navigation" do
    before(:each) do
      visit "/"
    end

    it "should link to the about us page" do
      click_link 'about'
      page.should have_content 'About Us'
    end

    it "should link to how it works" do
      click_link 'how'
      page.should have_content 'How copper works'
    end

    it "should link to the blog" do
      page.should have_content 'blog'
    end

    it "should link to the contact page" do
      click_link 'contact'
      page.should have_content 'contact'
      page.should have_content 'us@copper.is'
    end

    it "should link to the privacy page" do
      click_link 'privacy'
      page.should have_content 'Copper Privacy Policy'
    end

    it "should link to the terms page" do
      click_link 'terms'
      page.should have_content 'COPPER TERMS OF SERVICE'
    end
  end


  describe "unauthorized locations" do
    it "should not see user info" do
      visit "/users/current"
      page.should have_content('Sign In With')
    end

    it "should not see user tips" do
      visit "/users/current/tips"
      page.should have_content('Sign In With')
    end

  end



end