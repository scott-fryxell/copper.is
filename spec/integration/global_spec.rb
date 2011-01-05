require File.dirname(__FILE__) + '/../spec_helper'

describe "The standard Weave page" do
  fixtures :users, :roles_users
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

    it "should link to the blog" do
      assert_have_selector "#blog"
    end
    it "should contain a logo" do
      assert_have_selector "body > header > a"
    end

  end
  
  describe "courtesy navigation" do
    it "should provide a way to email the company" do
      assert_have_selector "#contact"
      assert_have_selector "body > footer > nav > h2 > a"
    end
    it "should link to a page that describes the Terms & Conditions for the service"
    it "should link to a page that describes the privacy policy for the service"
  end
end