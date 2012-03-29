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

    it "should visit authors" do
      click_link 'author'
      page.should have_content 'Author settings'
      page.should have_content 'Badge'
      page.should have_content 'Identities'
      within("section#badge > form") do
        page.should have_content 'Color'
        page.should have_content 'Size'
      end
    end

    it "should be able to see how many accounts are linked" do
      click_link 'author'
      within("section#identity > header > h2 > span") do
        page.should have_content '1'
      end

    end

    it "should have a link to the identities page" do
      click_link 'author'
      within("section#identity > a") do
        page.should have_content 'edit'
      end
    end

    describe "linking accounts" do
      before(:each) do
        click_link 'author'
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

      it "should be able to link their github account" do
        click_link "github_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.github"
      end

      it "should be able to link their vimeo account" do
        click_link "vimeo_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.vimeo"
      end

      it "should be able to link their soundcloud account" do
        click_link "soundcloud_sign_in"
        page.should have_content 'Successfully linked that account'
        page.should have_selector "section.soundcloud"
      end


    end

  end

end