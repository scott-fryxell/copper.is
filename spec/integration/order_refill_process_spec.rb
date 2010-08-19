require File.dirname(__FILE__) + '/../spec_helper'

describe "Placing an order" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions

  describe "when not logged in" do

    it "should not be possible" do
      visit "/checkout"
      response_body.should contain("PERMISSION DENIED")
    end
  end

  describe "when logged in" do
    before(:each) do
      visit "/"
      click_link "Log in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Log in"
      click_link "Home"
    end

    it "should provide a link to refill your account" do
      click_link "Refill my account"
    end

    it "should display an SSL secured form for submitting an order"

    describe "when submitting valid order information" do
      it "should allow the submission of valid order information"
      it "should display a page allowing confiration of order details"
      it "should allow order details to be changed after initial submit"
      it "should display a success page when the order is processed"
    end

    describe "when submitting invalid order information" do
      it "should display flash errors if required fields are left blank"
      it "should display flash erros if the amount of the order is invalid"
      it "should display card validation errors if the payment details are invalid"
      it "should display human readable errors if the payment gateway does not successfully process the card"
      it "should "
    end

    describe "after placing a valid order" do
      it "should redirect back to the page the fan was previously on"
      it "should redirect to the tip page and prefill the URL to be tipped if the fan entered the refill process after an insufficient funds error during tipping"
      it "should display the correct refill amount in the account pane"
    end
  end
end