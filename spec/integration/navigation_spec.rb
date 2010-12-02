require File.dirname(__FILE__) + '/../spec_helper'

describe "The standard Weave page" do
  before(:each) do
    visit "/"
  end

  it "should contain a global nav section" do
    assert_have_selector "body > header"
  end

  it "should contain a courtesy nav section" do
    assert_have_selector "body > footer"
  end
  it "should contain a content area" do
    assert_have_selector "body > section"
  end

  describe "global navigation" do

    it "should link to the blog"
    it "should contain a logo" do
      assert_have_selector "body > header > a"
    end

  end

  describe "account section" do
    describe "when signed in as a fan with a filled account" do
      before(:each) do
        click_link "Sign in or sign up"
        fill_in "email", :with => "test@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
      end

      it "should have an account section" do
        assert_have_selector "body > section > header > aside", :id => 'account'
      end

      it "should display the current user's name on the page" do
        response_body.should contain("test@test.com")
      end

      it "should link to a sign out action" do
        click_link "Sign out"
        response_body.should contain("Successfully signed out.")
      end

      it "should link to a tip page for a fan" do
        click_link "Tips"
        response_body.should contain("Leave a Tip")
      end

      it "should display the tip fund balance" do
        response_body.should contain("Balance $30")
      end

      it "should display the number of current tips" do
        response_body.should contain("Tips 8")
      end

      it "should display the current value of each tip" do
        response_body.should contain("Rate $0.25")
      end

      it "should link to a fan home page"
    end

    describe "when signed in as a fan with no refill" do
      before(:each) do
        click_link "Sign in or sign up"
        fill_in "email", :with => "patron@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
      end

      it "should have an account section" do
        assert_have_selector "body > section > header > aside", :id => 'account'
      end

      it "should display the current user's name on the page" do
        response_body.should contain("patron@test.com")
      end

      it "should link to a logout action" do
        click_link "Sign out"
        response_body.should contain("Successfully signed out.")
      end

      it "should encourage the fan to fund their account" do
        response_body.should contain("You need to refill your account in order to make tips.")
      end
    end

    describe "when signed in as a publisher" do
      before(:each) do
        click_link "Sign in or sign up"
        fill_in "email", :with => "publisher@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
      end

      it "should link to a publisher home page for a publisher"
    end


    describe "when signed in as an administrator" do
      before(:each) do
        click_link "Sign in or sign up"
        fill_in "email", :with => "admin@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
      end

      it "should link to a administrators home page for an administrator" do
        click_link "Admin"
        response_body.should contain("Admin home")
      end

    end

    describe "when not signed in" do
      it "should include a login or register widget when guest is unknown" do
        click_link "Sign in or sign up"
      end
    end
  end

  describe "courtesy navigation" do
    it "should link to an Terms & Conditions  page" do
      assert_have_selector "body > footer > nav"
      click_link "Terms & Conditions"
    end
    it "should link to an Terms & Conditions  page" do
      assert_have_selector "body > footer > nav"
      click_link "Privacy"
    end

    it "should link to a subscribe page" do
      assert_have_selector "body > footer > nav"
      click_link "Subscribe"
    end
    it "should link to a contact page" do
      assert_have_selector "body > footer > nav"
      click_link "Contact"
    end

    it "should contain the last 3 blog entries"
  end
end