require 'spec_helper'

describe 'Item.js', :slow do

  before :each do
    mock_user
    visit "/auth/facebook"
    sleep 2
    click_link 'Your account information'
  end

  it "should be able to query items on the page" do
    page.evaluate_script("$.items('user')").should_not be_nil
  end

  it "should be able to query for user email" do
    page.evaluate_script("('document.items.me.email").should == "user@facebook.com"
  end

  it "should be able to change email from the command line" do
    within "section#email" do
      find("div > p").should have_content("user@facebook.com")
      page.execute_script("document.me.email = 'change@email.com'")
      page.execute_script("$.update_view(document.items.me)")
      find("div > p").should have_content("change@email.com")
      click_link "Change"
      find_field('user[email]').value.should == 'change@email.com'
    end
  end
end

