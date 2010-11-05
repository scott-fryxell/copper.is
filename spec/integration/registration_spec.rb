require File.dirname(__FILE__) + '/../spec_helper'

describe "Account" do
  fixtures :roles_users, :users

  describe "registration" do

    before(:each) do
      visit "/"
      click_link "Sign in or sign up"
      choose "No, I need an account"
    end

    it "should display a registration form when the guest visits the registration url" do
      response_body.should contain("I need an account")
    end

    it "should allow a guest to register for an account" do
      fill_in "email", :with => "newguy@newguy.com"
      fill_in "password", :with => "thepassword"
      fill_in "password_confirmation", :with => "thepassword"
      click_button "Sign in"
      response_body.should contain("Registration successful. Please check your email for instructions on activating your account.")
    end

    it "should check to make sure the email address is not already registered for an account" do
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      fill_in "password_confirmation", :with => "test"
      click_button "Sign in"
      response_body.should contain("There is already a Weave account for that email address.")
    end

    it "should validate that the email address is valid" do
      fill_in "email", :with => "testtest"
      fill_in "password", :with => "test"
      fill_in "password_confirmation", :with => "test"
      click_button "Sign in"
      response_body.should contain("You must use a valid email address.")
    end

    it "should require a new user to confirm their password" do
      fill_in "email", :with => "confirmme@test.com"
      fill_in "password", :with => "test"
      fill_in "password_confirmation", :with => ""
      click_button "Sign in"
      response_body.should contain("Passwords did not match.")
    end

    it "should require that passwords be at least 4 characters long" do
      fill_in "email", :with => "confirmme@test.com"
      fill_in "password", :with => "tes"
      fill_in "password_confirmation", :with => "tes"
      click_button "Sign in"
      response_body.should contain("Password must be at least 4 characters long")
    end

    it "should not allow a non-active user to login" do
      fill_in "email", :with => "newguy@newguy.com"
      fill_in "password", :with => "thepassword"
      fill_in "password_confirmation", :with => "thepassword"
      click_button "Sign in"
      click_link "Sign in or sign up"
      fill_in "email", :with => "newguy@newguy.com"
      fill_in "password", :with => "thepassword"
      choose "Yes, I have a password:"
      click_button "Sign in"
      response_body.should contain("Your account hasn't been activated. Check your email for instructions on how to activate it.")
    end

  end

  describe "activation" do

    describe "with a good token" do
      before(:each) do
        @user = users(:inactive)
        visit "/activate/#{@user.perishable_token}"
      end

      it "should display a welcome page with bookmarklet installation instructions" do
        response_body.should contain("Install the Weave bookmarklet")
        assert_have_selector "body > section > ol > li > a", :id => "weave_us"
      end

      it "should automatically log the user in" do
        response_body.should contain("notactive@test.com")
      end

    end

    describe "with a bad token" do

      before(:each) do
        visit "/activate/123_bad_token"
      end

      it "should display an error message when user tries to use an invalid token to activate their account" do
        response_body.should contain("We couldn't activate your account. Enter your email address to get an activation email.")
      end

      it "should display a failure message when a user requests a new activation email with a known email address that is already activated" do
        fill_in "email", :with => "test@test.com"
        click_button "Request Activation"
        response_body.should contain("Your account is already active. Please login.")
      end

      it "should display a failure message when a user requests a new activation email with an unknown email address" do
        fill_in "email", :with => "unknownemail@unknown.com"
        click_button "Request Activation"
        response_body.should contain("No Weave account exists for that email address.")
      end

      it "should display a success message when a user requests a new activation email with a known email address that is not yet activated" do
        fill_in "email", :with => "notactive@test.com"
        click_button "Request Activation"
        response_body.should contain("Please check your email for instructions on activating your account.")
      end

    end

  end

end
