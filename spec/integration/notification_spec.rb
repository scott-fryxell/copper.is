require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Notification" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  before(:each) do
    visit "/"
    click_link "Log in or sign up"
  end

  describe "when an error is thrown" do
    before(:each) do
      fill_in "email", :with => "baduser@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
    end

    it "should display the proper error notification UI" do
      assert_have_selector "body > section > header > ol", :id => 'error'
      assert_have_no_selector "body > section > header > ol", :id => 'notice'
    end

  end

  describe "when a success flash message is thrown" do
    before(:each) do
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
    end

    it "should display the proper success notification UI" do
      assert_have_selector "body > section > header > ol", :id => 'notice'
      assert_have_no_selector "body > section > header > ol", :id => 'error'
    end

  end

end
