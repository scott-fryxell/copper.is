require File.dirname(__FILE__) + '/../spec_helper'


describe "Guest" do

  it "should not be availaBle" do
    visit "/users/current"
    page.should have_content('Sign In With')
  end

  describe "call to action" do
    before(:each) do
      visit "/"
    end

    describe "header" do
      it "should be displayed to new users" do
        page.should have_selector "body > section > header"
      end
    end

  end
end