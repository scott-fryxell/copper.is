require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Home Page" do
  fixtures :roles_users, :users

  before(:each) do
    visit "/"
  end

  describe "anouncement" do
    it "should only display when the user is a guest" do
      click_link "Sign in or sign up"
      fill_in "email", :with => "test@test.com"

      fill_in "password", :with => "test"
      choose "Yes, I have a password:"
      click_button "Sign in"
      response_body.should contain("Successfully logged in.")

      assert_have_no_selector 'body > section > header > figure'

    end

    it "should contain a reference to a design stylesheet" do
      assert_have_selector "body > section > style"
      response_body.should contain("import url(/design.css)")
    end

    it "should contain a reference to a behavior script" do
      assert_have_selector "body > section > script"
    end

    describe "header" do
      it "should be displayed to new users" do
        assert_have_selector "body > section > header"
        response_body.should contain("See something cool on the internets? Tip it")
      end

      it "should contain a graphic about the service" do
        assert_have_selector "body > section > header > figure > img"
      end

      it "should contain an x minimize" do
        assert_have_selector "body > section > header > span"
      end
      it "should contain a link to get started with the service" do
        assert_have_selector "body > section > header > a"
      end
    end

    # describe "searching and sorting" do
    #   it "should contain a search box" do
    #     assert_have_selector "body > section > form > input[type=search]"
    #   end
    # 
    #   it "should contain a sort selector" do
    #     assert_have_selector "body > section > form > select[name=sort]"
    #   end
    #   it "should contain a label for sort" do
    #     assert_have_selector "body > section > form > label[for=sort]"
    #   end
    #   it "should contain 6 trending tips" do
    #     assert_have_selector "body > section > ol"
    #     assert_have_selector "body > section > ol > li"
    #   end
    # 
    # end

  end


end