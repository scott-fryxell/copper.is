require File.dirname(__FILE__) + '/../spec_helper'

describe "Tipping" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  describe "as a guest " do
    it "should not be available" do
      visit "/tips/new"
      response_body.should contain("PERMISSION DENIED")
      visit "/tips"
      response_body.should contain("PERMISSION DENIED")
    end

    it "should save a failed tip attempt in the session while the guest logs in"
  end

  describe "from the UI as an authenticated fan with an active tip bundle" do
    before(:each) do
      visit "/"
      click_link "Sign in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
      click_link "Home"
    end

    it "should include a visually offset area into which page URLs can be pasted" do
      assert_have_selector "body > section > form", :id => "new_tip"
    end

    it "should include a large box into which page URLs can be pasted" do
      assert_have_selector "body > section > form > fieldset > textarea", :id => "uri"
    end

    it "should include a list of recent tips made by that user" do

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

    it "should not allow a URL without a host to be tipped" do
      fill_in "uri", :with => "foobar"
      click_button "tip"
      response_body.should contain("That is not a valid URL.")
    end

    it "should encourage the user to tip if they haven't tipped in the last week"
    it "should not have to worry about duplicate tips (same page in any 24 hour period)"
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

    describe "after tipping a page" do
      it "should display some stats about the page when a tip has occurred"
      it "should display the total amount of money the page has received"
      it "should display how much money the page has received in the last month"
      it "should display other sites the publisher owns"
      it "should display a link to view the publisher's info"
    end

  end

  describe "from the UI as an authenticated fan without any funds" do
    before(:each) do
      visit "/"
      click_link "Sign in or sign up"
      fill_in "email", :with => "patron@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
      visit "/tips"
    end

    it "should alert that there are no funds available for tipping" do
      response_body.should contain("You need to refill your account in order to make tips")
    end

    describe "attempting to make tips" do
      before(:each) do
        visit "/tips/new"
      end

      it "should place the user into the refill process" do
        response_body.should contain("Select your monthly tip stash amount")
      end

      it "should store the failed tip in the session during the refill process"

      it "should after completing the refill process return the user to the tip page with the failed tip prefilled in the form" do
        pending("deciding exactly what the flow should be and how the implementation will look")
        fill_in "order_amount_in_cents", :with => "1000"
        fill_in "account_billing_name", :with => "Martha Washington"
        fill_in "account_number", :with => "4111111111111111"
        fill_in "account_card_type_id", :with => "1"
        fill_in "account_verification_code", :with => "123"
        fill_in "account_expires_on_1i", :with => "2012"
        fill_in "account_expires_on_2i", :with => "6"
        fill_in "billing_address_line_1", :with => "1304 N. Sedgwick Street"
        fill_in "billing_address_city", :with => "Chicago"
        fill_in "billing_address_state", :with => "IL"
        fill_in "billing_address_postal_code", :with => "60610"
        fill_in "billing_address_country", :with => "US"
        click_button "continue"
        click_button "Make Payment"
        response_body.should contain("successful purchase")
        assert_have_selector "form", :id => "new_tip"
        assert_have_selector "body > section > form > fieldset > textarea", :id => "uri", :value => "http://wooloo.dk"
        field_with_id('uri').value.should == "http://wooloo.dk"
      end
    end
  end
end