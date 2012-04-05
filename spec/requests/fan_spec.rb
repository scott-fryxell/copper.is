require File.dirname(__FILE__) + '/../spec_helper'

describe "Fan account" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end

  it "should have some tips to look at" do
    click_link 'fan'
    click_link 'tips'
    page.should have_content 'Tips'
  end

  it "should be able to load the tip iframe javascript" do
    visit "/tips/embed_iframe.js"
  end

  it "should be able to change tip rate" do
    click_link 'fan'
    click_link 'tips'
    find_field('user[tip_preference_in_cents]').value.should == '50'
    page.select '$1.00', :from => 'user[tip_preference_in_cents]'
    click_link 'fan'
    click_link 'tips'
    find_field('user[tip_preference_in_cents]').value.should == '100'
  end

  describe "should be able to change email" do
    before do
      click_link 'fan'
      find_field('user[email]').value.should == 'user@google.com'
      fill_in('user[email]', :with => 'change@google.com')
    end
    
    after do
      click_link 'fan'
      find_field('user[email]').value.should == 'change@google.com'
    end

    it "and submit by clicking on 'Save'" do
      within("section#email") do
        click_on 'Save'
      end
    end
    
    it "and submit using the return key" 
    
  end
  
  describe "should be able to change name" do
    before do
      click_link 'fan'
      find_field('user[name]').value.should == 'google user'
      fill_in('user[name]', :with => 'joe fan')
    end
    
    after do
      click_link 'fan'
      find_field('user[name]').value.should == 'joe fan'
    end
    
    it "and submit by clicking on 'Save'" do
      within("section#name") do
        click_on 'Save'
      end
    end
    
    it "and submit using the return key" 
 end
  
  it "should only be able to change name to a valid email address" do
    click_link 'fan'
    find_field('user[email]').value.should == 'user@google.com'
    fill_in('user[email]', :with => 'bademailaddress')
    within("section#email") do
      click_on 'Save'
      page.should have_content 'invalid email'
      fill_in('user[email]', :with => 'change2@google.com')
      click_on 'Save'
    end
    click_link 'fan'
    find_field('user[email]').value.should == 'change2@google.com'
  end

end
