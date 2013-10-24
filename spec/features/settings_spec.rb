require 'spec_helper'

describe "A Fan", :slow do
  before(:each) do
    mock_user
    visit "/auth/facebook"
    sleep 2
    click_link 'Your account information'
  end

  describe 'Item.js' do
    it "should be able to query items on the page" do
      page.evaluate_script("document.getItems('users')").should_not be_nil
    end

    it "should be able to query for user email" do
      page.evaluate_script("document.me.email").should == "user@facebook.com"
    end

    it "should be able to change email from the command line" do
      within("section#email") do
        find("div > p").should have_content("user@facebook.com")
        page.execute_script("document.me.email = 'change@email.com'")
        page.execute_script("$('body').update_page(document.me)")
        find("div > p").should have_content("change@email.com")
        click_link "Change"
        find_field('user[email]').value.should == 'change@email.com'
      end
    end
  end

  it "Can see their name" do
    page.save_screenshot('tmp/screenshots/settings/01.png')
    find("#banner > hgroup > p").should have_content("facebook user")
  end

  it "can change their email address" do
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
    visit '/settings'
    within("section#email") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("change@email.com")
    end
  end

  it "can change their default tip amount" do
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

    visit '/settings'

    within("section#rate") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("1")
    end
  end

  it 'will see their default tip amount formated corectly'  do
    within("section#rate") do
      find("div > p").should have_content("0.75")
      click_link "Change"
      find_field('user[tip_preference_in_cents]').value.should == '75'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      find("div > p").should have_content("1")
    end
  end

  it "can update their credit card information" do
    within("#card") do
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 2
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      page.save_screenshot('tmp/screenshots/settings/03.png')
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
    visit '/settings'
    sleep 2
    page.save_screenshot('tmp/screenshots/settings/02.png')

    within("#card") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end
  end

  it "will be told if their credit card info is bad" do
    within("#card") do
      page.should have_css('form', :visible => true)
      fill_in('number', :with => '4000000000000002')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 3
      page.save_screenshot('tmp/screenshots/settings/o3')
      page.should have_css('form', :visible => true)
      page.should have_css('form > h1', :visible => true)
      page.should have_content('Your card was declined');
    end
  end

end
