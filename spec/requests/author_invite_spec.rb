require File.dirname(__FILE__) + '/../spec_helper'

describe "an Author profile page", :slow, :broken do

  before(:each) do
    mock_page_and_user
    twitter = FactoryGirl.create(:authors_twitter, identity_state:'wanted')
    visit"/#{twitter.provider}/#{twitter.username}"
  end


  it 'a guest should sign up with their provider ' do
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

  it 'should validate the email address' do
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

  it 'should validate the address' do
    click_on 'Submit!'
    page.should have_css("input[itemprop=payable_to].invalid", visible:true)
    page.should have_css("input[itemprop=line1].invalid", visible:true)
    page.should have_css("input[itemprop=city].invalid", visible:true)
    page.should have_css("input[itemprop=postal_code].invalid", visible:true)
    page.should have_css("select[itemprop=country_code].invalid", visible:true)
    page.should have_no_css("body > nav button.working", visible:true)

    fill_in 'user[payable_to]', with:'joe strummer'
    click_on 'Submit!'
    page.should have_no_css("input[itemprop=payable_to].invalid", visible:true)

    fill_in 'user[line1]', with:'643 big ass street'
    click_on 'Submit!'
    page.should have_no_css("input[itemprop=payable_to].invalid", visible:true)

    fill_in 'user[city]', with:'san francisco'
    click_on 'Submit!'
    page.should have_no_css("input[itemprop=city].invalid", visible:true)

    fill_in 'user[postal_code]', with:'94110'
    click_on 'Submit!'
    page.should have_no_css("input[itemprop=postal_code].invalid", visible:true)

    fill_in 'user[postal_code]', with:'94110'
    click_on 'Submit!'
    page.should have_no_css("input[itemprop=postal_code].invalid", visible:true)

    select('Andorra', :from => 'user[country_code]')
    click_on 'Submit!'
    page.should have_no_css("select[itemprop=country_code].invalid", visible:true)
  end

  it 'should take Author to their profile page after submit', :broken do
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
