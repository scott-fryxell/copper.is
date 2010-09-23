require File.dirname(__FILE__) + '/../spec_helper'

describe "Placing an order" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions

  def valid_post
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
  end

  def invalid_card_post
    fill_in "order_amount_in_cents", :with => "1000"
    fill_in "account_billing_name", :with => "Martha Washington"
    fill_in "account_number", :with => "1212121212121212" # bad card number
    fill_in "account_card_type_id", :with => "1"
    fill_in "account_verification_code", :with => "123"
    fill_in "account_expires_on_1i", :with => "2012"
    fill_in "account_expires_on_2i", :with => "6"
    fill_in "billing_address_line_1", :with => "1304 N. Sedgwick Street"
    fill_in "billing_address_city", :with => "Chicago"
    fill_in "billing_address_state", :with => "IL"
    fill_in "billing_address_postal_code", :with => "60610"
    fill_in "billing_address_country", :with => "US"
  end

  def invalid_order_post
    fill_in "order_amount_in_cents", :with => "apples" # bad amount
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
  end

  describe "when not logged in" do
    it "should not be possible" do
      visit "/orders/new"
      response_body.should contain("PERMISSION DENIED")
      visit "/orders"
      response_body.should contain("PERMISSION DENIED")
    end
  end

  describe "when logged in as a fan" do
    before(:each) do
      visit "/"
      click_link "Log in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
      click_link "Home"
      visit "/orders/new"
    end

    it "should be possible" do
      response_body.should contain("Select your monthly tip stash amount")
    end

    it "should display an SSL secured form for submitting an order"

    it "should display a form with all of the required form fields" do
      assert_have_selector "input", :id => 'order_amount_in_cents'
      assert_have_selector "input", :type=> 'checkbox', :id => 'order_rebill'
      assert_have_selector "select", :id => 'account_card_type_id'
      assert_have_selector "input", :id => 'account_billing_name'
      assert_have_selector "input", :id => 'account_number'
      assert_have_selector "select", :id => 'account_expires_on_1i'
      assert_have_selector "input", :id => 'account_verification_code'
      assert_have_selector "input", :id => 'billing_address_line_1'
      assert_have_selector "input", :id => 'billing_address_line_2'
      assert_have_selector "input", :id => 'billing_address_city'
      assert_have_selector "select", :id => 'billing_address_state'
      assert_have_selector "input", :id => 'billing_address_postal_code'
      assert_have_selector "select", :id => 'billing_address_country'
      assert_have_selector "input", :id => 'billing_address_phone'
    end

    describe "when submitting valid order information on the order form" do
      before(:each) do
        valid_post
      end

      it "should succeed" do
        click_button "continue"
        assert_have_no_selector "body > section > header > ol", :id => 'error'
      end

      it "should display a page allowing confiration of order details" do
        click_button "continue"
        response_body.should contain("Confirm your Refill")
      end

      it "should allow order details to be changed after initial submit" do
        click_button "continue"
        click_button "Change"
        response_body.should contain("Select your monthly tip stash amount")
      end

      it "should display a success page when the order is processed" do
        click_button "continue"
        click_button "Make Payment"
        response_body.should contain("Refill Complete")
      end

      it "should display the total, refill, and fee values on the order success page" do
        click_button "continue"
        click_button "Make Payment"
        response_body.should contain("Total 1000")
        response_body.should contain("Refill $xx.xx")
        response_body.should contain("Fee $xx.xx")
      end

      it "should display the order number on the order success page" do
        click_button "continue"
        click_button "Make Payment"
        response_body.should contain("Order # -NUMBER-")
      end

      it "should display the payment method on the order success page" do
        click_button "continue"
        click_button "Make Payment"
        response_body.should contain("visa 4111111111111111")
      end

      it "should obfuscate the card number by only displaying the last four digits"
    end

    describe "when submitting invalid order information" do
      it "should display flash errors if required fields are left blank" do
        click_button "continue"
        response_body.should contain("Account is invalid")
        response_body.should contain("Number is not a valid credit card number")
        response_body.should contain("Last name cannot be empty")
        response_body.should contain("Verification value is required")
        response_body.should contain("Line 1 can't be blank")
        response_body.should contain("City can't be blank")
        response_body.should contain("Postal code can't be blank")
      end

      it "should display human readable errors if the payment gateway does not successfully process the card" do
        invalid_card_post
        click_button "continue"
        response_body.should contain("Number is not a valid credit card number")
      end
    end

    describe "after placing a valid order" do
      before(:each) do
        valid_post
        click_button "continue"
        click_button "Make Payment"
      end

      it "should redirect to the tip page by default"
      it "should redirect back to the page the fan was previously on before starting the order process"
      it "should redirect to the tip page and prefill the URL to be tipped if the fan entered the refill process after an insufficient funds error during tipping"
      it "should display the correct refill amount in the account pane" do
      end
    end
  end
end