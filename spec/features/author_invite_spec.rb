require 'spec_helper'

describe "An Author", :slow do

  before(:each) do
    mock_page_and_user
    twitter = FactoryGirl.create(:author_twitter, identity_state:'wanted')
    visit"/#{twitter.provider}/#{twitter.username}"
  end
  it 'Can view a page with their tips before signing up'

  it 'Can register for their tips through an OAuth provider ' do
    page.should have_css('#banner', visible:true)
    page.should have_css('#login > figure > a', visible:true)
    page.should have_content 'Step 1: Login'
    page.should have_content 'Step 2: Email'
    page.should have_content 'Step 3: Get Check'
    click_link('Authorize twitter');
    page.should have_content 'Complete!'
    page.should have_content 'Step 2: Email'
    page.should have_content 'Step 3: Get Check'
  end

  it 'provide their email address' do
    page.should have_css("#email > form input[name='user[email]']")
    click_on 'Submit!'
    page.should have_css("#email > form input.invalid", visible:true)
    page.should have_no_css("body > nav button.working", visible:true)

    fill_in 'user[email]', with:'userexample.com'
    click_on 'Submit!'
    page.should have_css("#email > form input.invalid", visible:true)

    fill_in 'user[email]', with:'user@examplecom'
    click_on 'Submit!'
    page.should have_css("#email > form input.invalid", visible:true)

    fill_in 'user[email]', with:'user@example.com'
    click_on 'Submit!'
    page.should have_no_css("#email > form input.invalid", visible:true)
  end

  it 'will be introduced to their profile page after signing up' do
    click_link('Authorize twitter');
    fill_in 'user[email]', with:'user@example.com'
    fill_in 'user[payable_to]', with:'joe strummer'
    fill_in 'user[line1]', with:'643 big ass street'
    fill_in 'user[city]', with:'san francisco'
    fill_in 'user[postal_code]', with:'94110'
    select('Andorra', :from => 'user[country_code]')
    click_on 'Submit!'
    page.should have_no_css(".invalid", visible:true)
    page.should have_content 'Your pages'
  end
end
