require File.dirname(__FILE__) + '/../spec_helper'

describe "a fan's profile page", :slow do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    User.count.should == 1
    User.first.tip({url:'http://www.nytimes.com', title:'nytimes homepage', amount_in_cents:'50'})
    User.first.tip({url:'http://www.fasterlighterbetter.com', title:'faster lighter better', amount_in_cents:'50'})
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should have the fan's name in the title" do
    find("head > title").should have_content("facebook user")
  end

  it 'should display the number of authors tipped' do
    User.first.tips.count.should == 2
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
    visit '/fans/me'
    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.50');
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

    visit '/fans/me'

    within ('#pages > details > summary') do
      page.should have_content('2')
    end

  end

  it 'should be able to click on a tip and see info about it'
  it 'should show more content from the author they\'ve tiped'
  it 'should have a screen shot of each page that\'s been tipped'
end
