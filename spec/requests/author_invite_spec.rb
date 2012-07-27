require File.dirname(__FILE__) + '/../spec_helper'

describe "a author being invited to the service" do
  before(:each) do
    twitter = FactoryGirl.create(:identities_twitter, identity_state:'wanted')
    visit"/identities/#{twitter.id}/edit"
  end

  it 'should not see the other sign in options' do
    page.should have_css('#sign_in', visible:false)
  end

  it 'should not see the signed_in ' do
    click_link('Authorize twitter');
    page.should have_css('#signed_in', visible:false)
  end

  it 'should be able to authorize with the service' do
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
    page.should have_css("#email > form input.invalid")
  end
  it 'should validate the address'
  it 'should take Author to their profile page after submit'
end
