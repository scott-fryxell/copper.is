require 'spec_helper'

describe 'twitter demo' do
  before do
    visit '/'
    click_link 'facebook_sign_in'      
    click_link 'fan'
    page.select '$20.00', :from => 'user[tip_preference_in_cents]'      
    visit "/tips/agent/?uri=https%3A%2F%2Ftwitter.com%2F%23!%2Fbrokenbydawn&title=brokenbydawn%20(brokenbydawn)%20on%20Twitter"
    page.should have_content "brokenbydawn"
    sleep 2
    fill_in('email', :with => 'google_user@email.com')
    fill_in('number', :with => '4242424242424242')
    fill_in('cvc', :with => '666')
    select('April', :from => 'month')
    select('2015', :from => 'year')
    check('terms')
    click_on('Pay')
    sleep 5
  end
  
  it "should tweet brokenbydawn that they have a royalty check waiting", :focus do
    visit 'https://twitter.com/#!/copper_dev'
    page.should have_content "@brokenbydawn"
  end
  
  it "should take brokenbydawn to a service description with info about the royalty check"
  
  it "brokenbydawn logs in"
  
  it "brokenbydawn provides address info and agrees to service terms"
  
  it "a copper admin logs in and views royalty checks"
  
  it "a copper admin pays brokenbydawn for their tips"
  
end
