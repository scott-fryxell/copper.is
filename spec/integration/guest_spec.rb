require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest" do
  fixtures :users, :roles_users

  it "should not be available" do
    visit "/tips/new"
    response_body.should contain("PERMISSION DENIED")
    visit "/tips"
    response_body.should contain("PERMISSION DENIED")
  end

  it "should have access to a signin widget" do
    visit "/"
    assert_have_selector "#rpx_now_embed"
  end

  it "should be able to sign in from the list of steps to use the service" do
    visit "/"
    assert_have_selector "body > section > article ul li a.rpxnow"
  end


  describe "call to action" do
    before(:each) do
      visit "/"
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
      end

      it "should contain a graphic about the service" do
        assert_have_selector "body > section > header > figure > img"
      end

      it "should contain an x minimize" do
        assert_have_selector "body > section > header > span"
      end
    end

  end
end