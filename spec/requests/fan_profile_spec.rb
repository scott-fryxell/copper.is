require File.dirname(__FILE__) + '/../spec_helper'

describe "A fan's first experience with their profile page", :slow do

  before(:each) do
    visit "/"
    click_link 'connect with facebook'
    User.count.should == 1
    page.execute_script("jQuery.fx.off = true")
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should show the welcome message after user signs in" do
    page.should have_css('#install', visible:true)
    page.should have_css('#congrats', visible:false)
    page.should have_css('#facebook', visible:false)
    page.should have_css('#card', visible:false)
    page.should have_no_css('section.settings', visible:true)
    page.execute_script('$(document).trigger("copper_button_installed")')
    page.should have_css('#install', visible:false)
    page.should have_css('#congrats', visible:true)
    page.should have_css('#facebook', visible:true)
    page.should have_css('#card', visible:true)
  end

  it "should be able to fill out their credit card info" do
    page.execute_script('$(document).trigger("copper_button_installed")')
    within("#card") do
      page.should have_css('form', :visible => true)
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 3
      page.should have_css('form', :visible => false)
      page.should have_css('figure', :visible => true)
    end

  end
  it "should be told if their credit card info is bad" do
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
      page.should have_css('form', :visible => true)
      page.should have_css('figure', :visible => false)
      page.should have_css('form > h1', :visible => true)
      page.should have_content('Your card was declined');
    end
  end
end

describe "a fan's profile page", :slow do
  before(:each) do
    visit "/"
    click_link 'connect with facebook'
    User.count.should == 1
    User.first.tip({url:'http://www.nytimes.com', title:'nytimes homepage', amount_in_cents:'50'})
    User.first.tip({url:'http://www.fasterlighterbetter.com', title:'faster lighter better', amount_in_cents:'50'})
    visit "/"
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should have the fan's name in the title" do
    find("head > title").should have_content("facebook user")
  end

  it 'should display the number of authors tipped' do
    User.first.pages.count.should == 2
    # print page.html
    within '#stats > div:nth-child(2) > p' do
      page.should have_content('2');
    end
  end

  it 'should display their average tip amount' do
    within '#stats > div > p > span' do
      page.should have_content('0.75');
    end
  end

  it 'should be able to increase their default tip amount' do

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

  it 'should be able to reduce their default tip amount' do
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

  it 'should display information about their most recent tip' do
    within '#pages > details > summary > figure > figcaption' do
      page.should have_content('0.50');
    end
  end

  it 'should display their current list of tips' do
    page.should have_css('#pages > details', visible:true, count:2)
  end

  it 'should be able to cancel pending tips' do 
    within ('#pages > details') do
      click_on('X') 
    end
    page.should have_css('#pages > details', visible:true, count:1)
  end

  it 'should be able to change the tip amount' do
   within ('#pages > details') do
      within ('summary') do
        page.should have_content('0.50')
      end
      fill_in 'amount_in_dollars', with:'2'
      click_button('Save')

      within ('summary') do
        page.should have_content('2')
      end
    end

    visit '/'

    within ('#pages > details > summary') do
      page.should have_content('2')
    end

  end

  it 'should be able to click on a tip and see info about it'
  it 'should show more content from the author they\'ve tiped'
  it 'should have a screen shot of each page that\'s been tipped'
end
