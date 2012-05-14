require File.dirname(__FILE__) + '/../spec_helper'

describe "An Author" do
  before do
    visit "/"
    click_link 'twitter_sign_in'
  end
  
  # after do
  #   User.last.identities.each do |i|
  #     i.destroy
  #   end
  #   User.last.destroy
  # end
  
  it "should have a settings section" do
    click_link 'author'
    page.should have_content 'Author Settings'
    page.should have_content 'Identities'
    page.should have_content 'Royalties'
    page.should have_content 'Badge'
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

  describe "linking accounts" do
    before(:each) do
      click_link 'author'
      within("section#identity") do
        click_link 'edit'
      end
    end
    
    it "should only link an account once" do
      page.should have_content 'twitter user'
      # page.should have_content 'Welcome aboard!'
      click_link 'twitter_sign_in'
      page.should have_content 'Already linked that account'
    end

    it "should be able to link multiple accounts" do
      click_link 'facebook_sign_in'
      page.should have_content 'Successfully linked that account'
    end

    it "should see that their twitter account is linked" do
      page.should have_selector "section.twitter"
    end

    it "should be able to link their facebook account" do
      click_link "facebook_sign_in"
      # page.should have_content 'Successfully linked that account'
      page.should have_selector "section.facebook"
    end

    it "should be able to link their tumblr account" do
      click_link "tumblr_sign_in"
      # page.should have_content 'Successfully linked that account'
      page.should have_selector "section.tumblr"
    end

    it "should be able to link their github account" do
      click_link "github_sign_in"
      # page.should have_content 'Successfully linked that account'
      page.should have_selector "section.github"
    end

    it "should be able to link their vimeo account" do
      click_link "vimeo_sign_in"
      # page.should have_content 'Successfully linked that account'
      page.should have_selector "section.vimeo"
    end

    it "should be able to link their soundcloud account" do
      click_link "soundcloud_sign_in"
      # page.should have_content 'Successfully linked that account'
      page.should have_selector "section.soundcloud"
    end

    it "should be able to link their flickr account" do
      click_link "flickr_sign_in"
      page.should have_content 'Successfully linked that account'
      page.should have_selector "section.flickr"
    end

    it "should be able to remove an linked identity" do
      click_link 'facebook_sign_in'
      # page.should have_content 'Successfully linked that account'

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

  describe 'notifying a twitter that they have tips' do
    before do
      visit '/'
      click_link 'facebook_sign_in'
      click_link 'fan'
      page.select '$20.00', :from => 'user[tip_preference_in_cents]'
      visit "/tips/agent/?uri=https%3A%2F%2Ftwitter.com%2F%23!%2Fbrokenbydawn&title=brokenbydawn%20(brokenbydawn)%20on%20Twitter"
      page.should have_content "brokenbydawn"
      sleep 5
      fill_in('email', :with => 'google_user@email.com')
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Pay')
      sleep 5
      # puts "[[ " + Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour ]]"
    end

    slow_test do
      it "should tweet brokenbydawn that they are wanted"#  do
      #   with_resque_scheduler do
      #     visit 'https://twitter.com/#!/search/realtime/%40brokenbydawn'
      #     page.should have_content "@brokenbydawn"
      #   end
      # end

      it "should take brokenbydawn to a service description with info about the royalty check" # do
      #   Twitter.search("@brokenbydawn",rpp:1,result_type:"recent").first do |tweet|
      #     @ident_url = tweet[(tweet =~ %r{http://copper.is/}) + 17..-1].split(' ').first
      #   end
      #   @ident_url.should_not be_nil
      #   puts @ident_url
      #   visit @ident_url
      #   page.should have_content 'Foobar'
      # end
        # tweet = Twitter.search("@brokenbydawn",rpp:1,result_type:'recent',include_entities:true).first
        # puts "found this tweet: #{tweet.text}"
        # @ident_url = tweet.urls[0].expanded_url
        # @ident_url.should_not be_nil
        # puts "found this url in tweet, following it: #{@ident_url}"
        # visit @ident_url
        # page.should have_content 'Foobar'

      it "brokenbydawn logs in" # do
      #   Twitter.search("@brokenbydawn",rpp:1,result_type:"recent").first do |tweet|
      #     visit tweet[(tweet =~ %r{http://copper.is/}) + 17..-1].split(' ').first
      #   end
      #   click_link 'twitter_sign_in'
      # end

      it "brokenbydawn provides address info and agrees to service terms"

      it "a copper admin logs in and views royalty checks"

      it "a copper admin pays brokenbydawn for their tips"
    end
  end

end
