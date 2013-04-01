require File.dirname(__FILE__) + '/../spec_helper'

describe "a fan", :slow do
  describe "right after signing up" do

    before(:each) do
      mock_page_and_user
      visit "/auth/facebook"
      User.count.should == 1
      page.execute_script("jQuery.fx.off = true")
    end
    after(:each) do
      page.driver.error_messages.should be_empty
    end

    it "can install the copper tip extension" do
      page.save_screenshot('public/screenshots/onboarding/01.png')
      page.should have_css('#button', visible:true)
      page.should have_css('#congrats', visible:false)
      page.should have_css('#card', visible:false)
      page.execute_script('$(document).trigger("copper_button_installed")')
      page.should have_css('#button', visible:false)
      page.should have_css('#congrats', visible:true)
      page.should have_css('#card', visible:true)
    end

    it "can provide credit card information" do
      page.execute_script('$(document).trigger("copper_button_installed")')
      within("#card") do
        page.should have_css('form', :visible => true)
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        page.save_screenshot('public/screenshots/onboarding/02.png')
        click_on('Save')
        sleep 3
        page.should have_css('form', :visible => false)
        page.should have_css('figure', :visible => true)
        page.save_screenshot('public/screenshots/onboarding/03.png')
      end
    end

    it "will be told if their credit card info is bad", :vcr do
      page.execute_script('$(document).trigger("copper_button_installed")')
      within("#card") do
        page.should have_css('form', :visible => true)
        fill_in('number', :with => '4000000000000002')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Save')
        sleep 3
        page.save_screenshot('public/screenshots/onboarding/03.png')
        page.should have_css('form', :visible => true)
        page.should have_css('figure', :visible => false)
        page.should have_css('form > h1', :visible => true)
        page.should have_content('Declined');
      end
    end
  end
  describe "after tipping some pages" do

    before(:each) do
      mock_page_and_user
      visit "/auth/facebook"
      User.count.should == 1

      VCR.use_cassette('nytimes') do
        User.first.tip({url:'http://www.nytimes.com', title:'nytimes homepage', amount_in_cents:'50'})
      end
      VCR.use_cassette('fasterlighterbetter') do
        User.first.tip({url:'http://www.fasterlighterbetter.com', title:'faster lighter better', amount_in_cents:'50'})
      end
      visit "/"
    end
    after(:each) do
      page.driver.error_messages.should be_empty
    end

    it "can see their name" do
      page.save_screenshot('public/screenshots/profile/01.png')
      find("#banner > hgroup > p").should have_content("facebook user")
    end

    it 'can view the number of authors tipped' do
      User.first.pages.count.should == 2
      within '#stats > div:nth-child(2) > p' do
        page.should have_content('2');
      end
    end

    it 'can view their average tip amount' do
      within '#stats > div > p > span' do
        page.should have_content('0.75');
      end
    end

    it 'can increase the default tip amount' do

      click_on('+')

      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('1');
      end

      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('1');
      end

      visit '/'
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('1');
      end

      click_on('+')
      click_on('+')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('3');
      end

      click_on('-')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('2');
      end   

      click_on('+')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('3');
      end   
    end

    it 'can reduce the default tip amount' do
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.75');
      end

      within '#stats' do
        click_on('-')
      end
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.50');
      end
      visit '/'
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.50');
      end

      click_on('-')
      click_on('-')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.10');
      end   
      click_on('+')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.25');
      end
      click_on('-')
      within 'span[itemprop="tip_preference_in_cents"]' do
        page.should have_content('0.10');
      end
    end

    it 'can see the most recent tip' do
      page.execute_script('$("#pages > details:nth-child(2)").attr("open", "open")')
      sleep 1.5
      within '#pages > details:nth-child(2) > summary > figure > figcaption' do
        page.should have_content('0.50');
      end
      page.save_screenshot('public/screenshots/profile/02.png')
    end

    it 'can see their tipped pages ' do
      page.should have_css('#pages > details', visible:true, count:2)
    end

    it 'can cancel a pending tip' do 
      within ('#pages > details:nth-child(2)') do
        page.find("input[type=image]").click
      end
      page.should have_css('#pages > details', visible:true, count:1)
    end

    it 'can change the tip amount' do

      within ('#pages > details:nth-child(2) > summary') do
        page.should have_content('0.50')
      end

      within ('#pages > details:nth-child(2) details') do
        fill_in 'amount_in_dollars', with:'2'
        click_button('Save')
      end

      within ('#pages > details:nth-child(2) > summary') do        
        page.should have_content('2')
      end

      visit '/'

      within ('#pages > details:nth-child(2) > summary') do
        page.should have_content('2')
      end
    end
  end
end
