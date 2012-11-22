require File.dirname(__FILE__) + '/../spec_helper'

describe "a authors's settings page", :slow do
  before :each  do
  visit '/'
  click_link 'facebook_sign_in'
  visit "/authors/me/edit"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it 'should be able to authorize facebook' do
    within '#identities figure.facebook > figcaption' do
      page.should have_content('facebook.user');
    end

    within '#identities' do
      click_link 'Add/Remove'
      page.should have_css('figure.facebook figcaption', visible:true)
      page.should have_css('aside', visible:true)
    end
  end

  it "should always have at least one identity authorized" do
    page.should have_no_css('#identities figure form')
  end

  it "should be able to show and hide identies that can be added" do
    within '#identities' do
      click_link 'Add/Remove'
      page.should have_css('figure > figcaption', visible:true)
      # page.should have_css('figure > form', visible:true) #WTF
      page.should have_css('aside', visible:true)

      click_link 'Done'
      page.should have_css('figure > figcaption', visible:false)
      # page.should have_css('figure > form', visible:false) #WTF
      page.should have_css('aside', visible:false)

    end

  end

  it "should be able to authorize multible identities" do
    within '#identities' do
      page.should have_css('figure', count:1)
      click_link 'Add/Remove'
      click_link 'Authorize twitter'
      page.should have_css('figure', count:2)
    end
  end

  it "should be able to deauthorize identities" do
    within '#identities' do
      click_link 'Add/Remove'
      click_link 'Authorize twitter'
      click_link 'Add/Remove'
    end
    page.should have_css('#identities')
    within 'figure.twitter' do
      click_on 'X'
    end
    page.should have_css('#identities figure', count:1)
    page.should have_css('#identities figure form', visible:false)
  end
  

  it 'should be able to change their email' do
    find('#email > div > p').should have_content('user@facebook.com')
    find_field('user[email]').value.should have_content('user@facebook.com')

    within '#email' do
      click_link 'Change'
      fill_in 'user[email]', with:'test@example.com'
      click_on 'Save'
    end

    within '#email > div' do
      page.should have_content('test@example.com')
    end
    
    visit "/authors/me/edit"
    find('#email > div > p').should have_content('test@example.com')
    find_field('user[email]').value.should have_content('test@example.com')
  end

  it 'should be able to change their address'
end
