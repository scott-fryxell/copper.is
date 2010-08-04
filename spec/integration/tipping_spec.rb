require File.dirname(__FILE__) + '/../spec_helper'

describe "Tipping" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  describe "a page" do

    it "should display some stats about the page when a tip has occurred"
    it "should display the total amount of money the page has received"
    it "should display how much money the page has received in the last month"
    it "should display other sites the publisher owns"
    it "should display a link to view the publisher's info"
  end

  describe "from the service's tip page" do
    before(:each) do
      visit "/"
      click_link "Log in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
      click_link "Home"
    end

    it "should include a visually offset area into which page URLs can be pasted" do
      assert_have_selector "body > section > form", :id => "new_tip"
    end

    it "should include a large box into which page URLs can be pasted" do
      assert_have_selector "body > section > form > fieldset > textarea", :id => "uri"
    end

    it "should include a list of recent tips made by that user" do
      assert_have_selector "body > section > table > caption", :content => "My current tips"
      assert_have_selector "body > section > table > tbody > tr > td", :content => "http://example.com/"
    end

    it "should be able to tip a page" do
      fill_in "uri", :with => "http://www.google.com"
      click_button "tip"
      assert_have_selector "body > section > table > tbody > tr > td", :content => "http://www.google.com/"
    end

    it "should thank users when a tip is successfully given" do
      fill_in "uri", :with => "http://www.google.com"
      click_button "tip"
      response_body.should contain("Tip successfully created.")
    end

    it "should encourage the user to tip if they haven't tipped in the last week"

    it "should tell fans how many tips they've made recently"
    it "should paginate the list of recent tips if it includes more than 20 items"

    describe "and the tip is a duplicate" do
      it "should indicate the duplicate tip did not go through"
      it "should include a message encouraging the user to tip elsewhere"
    end


    describe "the recent tip list area" do
      it "should include the title of the page"

      it "should include the URL for the page" do
        assert_have_selector "body > section > table > tbody > tr > td", :content => "http://example.com/"
      end

      it "should have the URL for the page smaller and lower contrast than the title"
      it "should include the human-readable time since the tip was given"
    end

  end

  describe "as a fan" do
    it "should be logged in to make a tip" do
      visit "/tips/new"
      response_body.should contain("PERMISSION DENIED")
    end

    it "should be logged in to see tips" do
      visit "/tips"
      response_body.should contain("PERMISSION DENIED")
    end

    it "should have a tip queued up while they go through the authentication process"
    it "should have funds availabile for the tip"
    it "should not have to worry about duplicate tips (same page in any 24 hour period)"
  end

end
