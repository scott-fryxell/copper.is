require File.dirname(__FILE__) + '/../spec_helper'

describe "a fan's profile page" do
  before(:each) do
    visit "/"
    click_link 'facebook_sign_in'
    visit "/test"
  end

  it 'should display the number of authors tipped', :focus do
    visit '/users/me'
    Tip.count.should == 1
    within('#stats > div > p') do
      page.should have_content('1');
    end
  end

  it 'should display their average tip amount' do
    within('#stats > div > p') do
      page.should have_content('0.25');
    end
  end

  it 'should be able to change their tip amount'
  it 'should display the number of authors tipped'

  it 'should display their current list of tips'
  it 'should display information about their most recent tip'
  it 'should be able to click on a tip and see info about it'
  it 'should be able to cancel pending tips'
  it 'should show more content from the author they\'ve tiped'
end
