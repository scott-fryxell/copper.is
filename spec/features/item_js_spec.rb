require 'spec_helper'

describe 'Item.js', :slow, :type => :feature do

  before :each do
    mock_user
    visit "/auth/facebook"
    sleep 2
    click_link 'Your account information'
  end

  it "should be able to query items on the page" do
    expect(page.evaluate_script("$.items('user')")).not_to be_nil
  end

  it "should be able to query for user email" do
    expect(page.evaluate_script("('document.items.me.email")).to eq("user@facebook.com")
  end

  it "should be able to change email from the command line" do
    within "section#email" do
      expect(find("div > p")).to have_content("user@facebook.com")
      page.execute_script("document.me.email = 'change@email.com'")
      page.execute_script("$.update_view(document.items.me)")
      expect(find("div > p")).to have_content("change@email.com")
      click_link "Change"
      expect(find_field('user[email]').value).to eq('change@email.com')
    end
  end
end

