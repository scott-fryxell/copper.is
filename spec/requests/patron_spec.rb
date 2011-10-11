require File.dirname(__FILE__) + '/../spec_helper'

describe "Patron" do
  fixtures :roles, :users, :roles_users


  describe "account settings" do
    before(:each) do
    end

    it "should have a page to manage account settings"

  end

  # describe "account section" do
  #   describe "when signed in as a fan" do
  #     before(:each) do
  #       visit "/account"
  #     end
  #      it "should not display the call to action when the user is a guest" do
  #        assert_have_no_selector 'body > section > header > figure'
  #      end
  #
  #     it "should have an account section" do
  #       assert_have_selector "body > section > header > aside", :id => 'account'
  #     end
  #
  #     it "should display the current user's name on the page" do
  #       response_body.should contain("joe_fan")
  #     end
  #
  #     it "should link to a sign out action" do
  #       click_link "Sign out"
  #       response_body.should contain("Successfully signed out.")
  #     end
  #
  #     it "should link to a tip page for a fan" do
  #       click_link "Tips"
  #       response_body.should contain("Leave a Tip")
  #     end
  #
  #     it "should display the number of current tips" do
  #       response_body.should contain("Tips 8")
  #     end
  #
  #     it "should display the current value of each tip" do
  #       response_body.should contain("$0.25")
  #     end
  #
  #   end
  #
  #
  #   describe "when signed in as an administrator" do
  #     before(:each) do
  #       click_link "Sign in or sign up"
  #       fill_in "email", :with => "admin@test.com"
  #       fill_in "password", :with => "test"
  #       choose "Yes, I have a password:"
  #       click_button "Sign in"
  #     end
  #
  #     it "should link to a administrators home page for an administrator" do
  #       click_link "Admin"
  #       response_body.should contain("Admin home")
  #     end
  #
  #   end
  #
  # end
  #
  #
  # describe "from the UI as" do
  #   before(:each) do
  #     UserSession.create(users(:patron))
  #     visit "/"
  #   end
  #
  #   it "should include a visually offset area into which page URLs can be pasted" do
  #     assert_have_selector "body > section > header > form", :id => "new_tip"
  #   end
  #
  #   it "should include a large box into which page URLs can be pasted" do
  #     assert_have_selector "body > section > header > form > fieldset > textarea", :id => "uri"
  #   end
  #
  #   it "should include a list of recent tips" do
  #     assert_have_selector "body > section > table > tbody > tr > td", :content => "http://example.com/"
  #   end
  #
  #   it "should be able to tip a page" do
  #     fill_in "uri", :with => "http://www.google.com"
  #     click_button "tip"
  #     assert_have_selector "body > section > table > tbody > tr > td", :content => "http://www.google.com/"
  #   end
  #
  #   it "should thank users when a tip is successfully given" do
  #     fill_in "uri", :with => "http://www.google.com"
  #     click_button "tip"
  #     response_body.should contain("Tip successfully created.")
  #   end
  #
  #   it "should not allow a URL without a host to be tipped" do
  #     fill_in "uri", :with => "foobar"
  #     click_button "tip"
  #     response_body.should contain("That is not a valid URL.")
  #   end
  #
  #
  #   it "should tell fans how many tips they've made recently"
  #   it "should paginate the list of recent tips if it includes more than 20 items"
  #
  #
  #   describe "the recent tip list area" do
  #     it "should include the title of the page"
  #
  #     it "should include the URL for the page" do
  #       assert_have_selector "body > section > table > tbody > tr > td", :content => "http://example.com/"
  #     end
  #
  #     it "should have the URL for the page smaller and lower contrast than the title"
  #     it "should include the human-readable time since the tip was given"
  #   end
  #
  #   describe "after tipping a page" do
  #     it "should display some stats about the page when a tip has occurred"
  #     it "should display the total amount of money the page has received"
  #     it "should display how much money the page has received in the last month"
  #     it "should display other sites the publisher owns"
  #     it "should display a link to view the publisher's info"
  #   end
  #
  # end

end