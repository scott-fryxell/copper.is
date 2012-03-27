require File.dirname(__FILE__) + '/../spec_helper'

describe "Identity" do

  describe "An Author" do
    before(:each) do
      visit "/"
      click_link 'twitter_sign_in'
    end

    it "should only link an account once" do
      page.should have_content 'twitter user'
      page.should have_content 'Welcome aboard!'
      visit "/users/current/identities"
      click_link 'twitter_sign_in'
      page.should have_content 'Already linked that account'
    end

    it "should be able to link multiple accounts" do
      page.should have_content 'twitter user'
      page.should have_content 'Welcome aboard!'
      visit "/users/current/identities"
      click_link 'facebook_sign_in'
      page.should have_content 'Successfully linked that account'
    end

    it "should be able to see how many accounts are linked" do
      click_link 'twitter user'

      within("section#identity > div > span") do
        page.should have_content '1'
      end

    end

    it "should have a link to the identities page" do
      click_link 'twitter user'

      within("section#identity > div > a") do
        page.should have_content 'edit'
      end
    end

    describe "linking accounts" do
      before(:each) do
        click_link 'twitter user'
        within("section#identity") do
          click_link 'edit'
        end
      end

      it "should see that their twitter account is linked" do
        page.should have_selector "section.twitter"
      end

      it "should be able to link their facebook account" do
        click_link "facebook_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.facebook"
      end

      it "should be able to link their tumblr account" do
        click_link "tumblr_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.tumblr"
      end
      
      it "should be able to link their github account", do
        click_link "github_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.github"
      end
      
    end

  end

end