require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Reports" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  before(:each) do
    visit "/"
  end

  describe "reporting" do
    before(:each) do
      click_link "Discover"
    end

    describe "with the most tips" do
      it "should" do
        assert_have_selector "body > section > ol > li dl"
        response_body.should contain("popular.com")
      end
    end

    describe "with the most revenue" do
      it "should" do
        assert_have_selector "body > section > ol > li > dl"
        response_body.should contain("popular.com")
      end
    end

  end

end