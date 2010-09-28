require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Admin" do
  fixtures :users, :roles_users

  before(:each) do
    visit "/"
    click_link "Sign in or sign up"
    fill_in "email", :with => "admin@test.com"
    fill_in "password", :with => "test"
    choose "Yes, I have a password:"
    click_button "Sign in"
    visit "/admin"
  end

  describe "home page" do
    it "should be accessible to users with the Admininstrator role" do
      response_body.should contain("Admin home")
    end

    it "should link to the recently added users report" do
      click_link "Users recently added and active"
      response_body.should contain("Users: Recently added and active")
    end

    describe "access" do
      before(:each) do
        click_link "Sign out"
        click_link "Sign in or sign up"
      end

      it "should not be given to guests" do
        visit "/admin"
        response_body.should contain("PERMISSION DENIED")
      end

      it "should not be given to patrons" do
        fill_in "email", :with => "patron@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
        visit "/admin"
        response_body.should contain("PERMISSION DENIED")
      end

      it "should not be given to publishers" do
        fill_in "email", :with => "publisher@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
        visit "/admin"
        response_body.should contain("PERMISSION DENIED")
      end

      it "should not be given to developers" do
        fill_in "email", :with => "developer@test.com"
        fill_in "password", :with => "test"
        choose "Yes, I have a password:"
        click_button "Sign in"
        visit "/admin"
        response_body.should contain("PERMISSION DENIED")
      end
    end
  end

  describe "recently added and active users report" do
    before(:each) do
      click_link "Users recently added and active"
    end

    it "should have a link back to the admin page" do
      click_link "Admin"
      response_body.should contain("Admin home")
    end

    it "should display active users" do
      response_body.should contain("test@test.com")
    end

    it "should not display inactive users" do
      response_body.should_not contain("notactive@test.com")
    end

    it "should not be available to non-admin users" do
      click_link "Sign out"
      click_link "Sign in or sign up"
      fill_in "email", :with => "test@test.com"
      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
      visit "/admin/reports/users/active"
      response_body.should contain("PERMISSION DENIED")
    end
  end
end