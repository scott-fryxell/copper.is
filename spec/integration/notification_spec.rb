require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Notification" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  before(:each) do
    visit "/"
    click_link "Sign in or sign up"
  end

  describe "when an message for the user is set" do
    before(:each) do
      fill_in "email", :with => "baduser@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
    end

    it "should display in the header of the UI" do
      assert_have_selector "body > header > ol > li"
    end

  end

end
