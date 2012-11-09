require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan's settings page", :slow do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    click_link 'Account settings'
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  describe 'Item.js' do
    it "should be able to query items on the page" do
      page.evaluate_script("document.getItems('fans')").should_not be_nil
    end

    it "should be able to query for user email" do
      page.evaluate_script("copper.me.email").should == "user@facebook.com"
    end

    it "should be able to change email from the command line" do
      within("section#email") do
        find("div > p").should have_content("user@facebook.com")
        page.execute_script("copper.me.email = 'change@email.com'")
        page.execute_script("Item.update_page(copper.me)")
        find("div > p").should have_content("change@email.com")
        click_link "Change"
        find_field('user[email]').value.should == 'change@email.com'
      end
    end

  end

  it "should have the fan's name in the title" do
    find("head > title").should have_content("facebook user")
  end

  it "should be able to change email" do
    within("#email") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("user@facebook.com")
      click_link "Change"
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)

      find_field('user[email]').value.should == 'user@facebook.com'
      fill_in('user[email]', :with => 'change@email.com')
      click_on 'Save'
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("change@email.com")
    end
    click_link 'Account settings'
    within("section#email") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("change@email.com")
    end
  end

  it "should be able to change tip amount preference" do
    within("section#rate") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)

      find("div > p").should have_content("0.75")
      click_link "Change"
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)

      find_field('user[tip_preference_in_cents]').value.should == '75'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("1")
    end
    click_link 'Account settings'
    within("section#rate") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("1")
    end
  end

  it 'should add a zero for any tip amount less then a dollar' do
    within("section#rate") do
      find("div > p").should have_content("0.75")
      click_link "Change"
      find_field('user[tip_preference_in_cents]').value.should == '75'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      find("div > p").should have_content("1")
    end
  end

  it "should be able to save their credit card information" do
    within("#card") do
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)

      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end

    within("#card") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end

    click_link 'Account settings'

    within("#card") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end

  end

end
