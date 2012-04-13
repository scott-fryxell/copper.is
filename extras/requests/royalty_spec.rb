require File.dirname(__FILE__) + '/../spec_helper'

describe "author royalties" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
    click_link 'author'
    click_link 'royalties'
  end
  
  it "have a list of all royalty orders" do
    page.should have_content 'Royalties'
  end
end