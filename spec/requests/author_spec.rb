require File.dirname(__FILE__) + '/../spec_helper'

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

  it "should have a link to royalty orders" do
    click_link 'author'
    page.should have_content 'royalties'
  end

  it "should have a link to the identities page" do
    click_link 'author'
    within("section#identity > a") do
      page.should have_content 'edit'
    end
  end

  it "should have a link to the badge page" do
    click_link 'author'
    within("section#badge > a") do
      page.should have_content 'badge'
    end
  end

  it "should have a badge page" do
    click_link 'author'
    click_link 'badge'
    page.should have_content 'Use the Badge on your page'
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

    it "should be able to link their flickr account" do
      click_link "flickr_sign_in"
      page.should have_content 'Successfully linked that account'
      page.should have_selector "section.flickr"
    end

    it "should be able to remove an linked identity" do
      click_link 'facebook_sign_in'
      page.should have_content 'Successfully linked that account'

      within("section.facebook") do
        click_on 'remove'
      end
      page.should have_content 'Removed that Identity'

      page.should_not have_selector "section.facebook"
      page.should_not have_content 'remove'
    end

    it "should not be able to delete and a identity when there is only one" do
      page.should_not have_content 'remove'
    end
  end

  slow_test do
    describe "on author's royalties page" do
      before do
        visit "/"
        click_link 'google_sign_in'
        visit "/tips/agent/?uri=http://twitter.com/#!/brokenbydawn"
        click_on('Change')
        fill_in('tip_amount', :with => '10.50')
        click_on('save')
        visit "/tips/agent/?uri=http://twitter.com/#!/brokenbydawn"
        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
      end
      it 'displays a royal check on the authors royalty page'
    end
  end

  describe "author royalties" do
    before(:each) do
      click_link 'author'
      click_link 'royalties'
    end

    it "have a list of all royalty checks" # do
    #  page.should have_content 'Royalties'
    #end
  end
end
