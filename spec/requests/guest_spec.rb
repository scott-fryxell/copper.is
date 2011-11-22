require File.dirname(__FILE__) + '/../spec_helper'

describe "Guest" do

  it "should not be availaBle" do
    visit "/users/current"
    page.should have_content('Sign In With')
    visit "/users/current/tips"
    page.should have_content('Sign In With')

  end

  describe "call to action" do
    before(:each) do
      visit "/"
    end

    it "should contain a reference to a design stylesheet" do
      page.should have_selector "body > section > style"
      page.should have_content 'import url(/design.css)'
    end

    describe "header" do
      it "should be displayed to new users" do
        page.should have_selector "body > section > header"
      end

      it "should contain a graphic about the service" do
        page.should have_selector "body > section > header > figure > img"
      end
    end

  end
end