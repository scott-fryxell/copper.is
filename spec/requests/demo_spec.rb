require 'spec_helper'

describe 'twitter demo', :focus do
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
    puts "[[ " + Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour ]]"
  end

  slow_test do
    it "should tweet brokenbydawn that they are wanted" do
      with_resque_scheduler do
        visit 'https://twitter.com/#!/search/realtime/%40brokenbydawn'
        page.should have_content "@brokenbydawn"
      end
    end
    
    it "should take brokenbydawn to a service description with info about the royalty check" #, :focus do
    #   Twitter.search("@brokenbydawn",rpp:1,result_type:"recent").first do |tweet|
    #     @ident_url = tweet[(tweet =~ %r{http://copper.is/}) + 17..-1].split(' ').first
    #   end
    #   @ident_url.should_not be_nil
    #   puts @ident_url
    #   visit @ident_url
    #   page.should have_content 'Foobar'
    # end
      tweet = Twitter.search("@brokenbydawn",rpp:1,result_type:'recent',include_entities:true).first
      puts "found this tweet: #{tweet.text}"
      @ident_url = tweet.urls[0].expanded_url
      @ident_url.should_not be_nil
      puts "found this url in tweet, following it: #{@ident_url}"
      visit @ident_url
      page.should have_content 'Foobar'
    
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
