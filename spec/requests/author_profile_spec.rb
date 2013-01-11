require File.dirname(__FILE__) + '/../spec_helper'

describe "a authors profile page", :slow do
  before :each  do
    visit "/"
    click_link 'connect with facebook'
    visit "/authors/me/edit"

  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end


  it 'should tell the author how many tips they\'s made'
  it 'should tell the author how many tips have been paid'
  it 'should tell the author how many tips are pending'
  it 'should tell the author what their highest tip was'
  it 'should tell the author what their average tip is'
  it 'should tell the author what their tota tip amount is'
  it 'should list the pages the author has been tipped for'
  it 'should provide the author with a way to embed the badge on the page'
  it 'should have a link to the authors settings page'
end
