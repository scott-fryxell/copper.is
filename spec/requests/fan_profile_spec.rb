require File.dirname(__FILE__) + '/../spec_helper'

describe "a fan's profile page", :slow do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    User.count.should == 1
    User.first.tip({url:'http://www.nytimes.com', title:'nytimes homepage', amount_in_cents:'50'})
    User.first.tip({url:'http://www.fasterlighterbetter.com', title:'faster lighter better', amount_in_cents:'50'})
    visit '/fans/me'
  end
  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it 'should display the number of authors tipped' do
    User.first.tips.count.should == 2
    within '#stats > div:nth-child(2) > p' do
      page.should have_content('2');
    end
  end

  it 'should display their average tip amount' do
    within '#stats > div > p > span' do
      page.should have_content('0.50');
    end
  end

  it 'should be able to increase their default tip amount' do

    click_on('+')

    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.75');
    end

    visit '/fans/me'

    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.75');
    end
  end

  it 'should be able to reduce their default tip amount' do
    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.50');
    end

    within '#stats' do
      click_on('-')
    end
    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.25');
    end
    visit '/fans/me'
    within 'span[itemprop="tip_preference_in_cents"]' do
      page.should have_content('0.25');
    end
  end

  it 'should display information about their most recent tip' do
    within '#tips > aside > figure > figcaption' do
      page.should have_content('0.50');
    end
  end

  it 'should display their current list of tips' do
    within '#tips > ol' do
      page.should have_css('li', visible:true, count:2)
    end
  end
  it 'should be able to click on a tip and see info about it'

  it 'should be able to cancel pending tips' do pending
    click_on('Cancel tip')
    within '# > ol' do
      page.should have_css('li', visible:true, count:1)
    end
  end
  it 'should show more content from the author they\'ve tiped'
  it 'should have a screen shot of each page that\'s been tipped'
end
