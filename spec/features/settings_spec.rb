require 'spec_helper'

describe "A Fan", :slow, :type => :feature do
  before(:each) do
    mock_user
    visit "/auth/facebook"
    sleep 2
    click_link 'Your account information'
  end

  describe 'Item.js' do
    it "should be able to query items on the page" do
      expect(page.evaluate_script("document.getItems('users')")).not_to be_nil
    end

    it "should be able to query for user email" do
      expect(page.evaluate_script("document.me.email")).to eq("user@facebook.com")
    end

    it "should be able to change email from the command line" do
      within("section#email") do
        expect(find("div > p")).to have_content("user@facebook.com")
        page.execute_script("document.me.email = 'change@email.com'")
        page.execute_script("$('body').update_page(document.me)")
        expect(find("div > p")).to have_content("change@email.com")
        click_link "Change"
        expect(find_field('user[email]').value).to eq('change@email.com')
      end
    end
  end

  it "Can see their name" do
    page.save_screenshot('tmp/screenshots/settings/01.png')
    expect(find("#banner > hgroup > p")).to have_content("facebook user")
  end

  it "can change their email address" do
    within("#email") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div > p")).to have_content("user@facebook.com")
      click_link "Change"
      expect(page).to have_css('form', :visible => true)
      expect(page).to have_css('div', :visible => false)

      expect(find_field('user[email]').value).to eq('user@facebook.com')
      fill_in('user[email]', :with => 'change@email.com')
      click_on 'Save'
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div > p")).to have_content("change@email.com")
    end
    visit '/settings'
    within("section#email") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div > p")).to have_content("change@email.com")
    end
  end

  it "can change their default tip amount" do
    within("section#rate") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)

      expect(find("div > p")).to have_content("0.75")
      click_link "Change"
      expect(page).to have_css('form', :visible => true)
      expect(page).to have_css('div', :visible => false)

      expect(find_field('user[tip_preference_in_cents]').value).to eq('75')
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div > p")).to have_content("1")
    end

    visit '/settings'

    within("section#rate") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div > p")).to have_content("1")
    end
  end

  it 'will see their default tip amount formated corectly'  do
    within("section#rate") do
      expect(find("div > p")).to have_content("0.75")
      click_link "Change"
      expect(find_field('user[tip_preference_in_cents]').value).to eq('75')
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      expect(find("div > p")).to have_content("1")
    end
  end

  it "can update their credit card information" do
    within("#card") do
      expect(page).to have_css('form', :visible => true)
      expect(page).to have_css('div', :visible => false)
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 2
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      page.save_screenshot('tmp/screenshots/settings/03.png')
      expect(find("div p.number")).to have_content("4242")
      expect(find("div p.type")).to have_content("Visa")
      expect(find("div p.expiration")).to have_content("4/2015")
    end

    within("#card") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div p.number")).to have_content("4242")
      expect(find("div p.type")).to have_content("Visa")
      expect(find("div p.expiration")).to have_content("4/2015")
    end
    visit '/settings'
    sleep 2
    page.save_screenshot('tmp/screenshots/settings/02.png')

    within("#card") do
      expect(page).to have_css('form', :visible => false)
      expect(page).to have_css('div', :visible => true)
      expect(find("div p.number")).to have_content("4242")
      expect(find("div p.type")).to have_content("Visa")
      expect(find("div p.expiration")).to have_content("4/2015")
    end
  end

  it "will be told if their credit card info is bad" do
    within("#card") do
      expect(page).to have_css('form', :visible => true)
      fill_in('number', :with => '4000000000000002')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 3
      page.save_screenshot('tmp/screenshots/settings/03')
      expect(page).to have_css('form', :visible => true)
      expect(page).to have_css('form > h1', :visible => true)
      expect(page).to have_content('Your card was declined');
    end
  end

end
