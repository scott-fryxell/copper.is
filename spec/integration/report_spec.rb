require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Reports" do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites
  
  before(:each) do
    visit "/"
  end
  
  describe "sites" do
    before(:each) do
      click_link "Sites"
    end
    
    describe "with the most tips" do
      it "should" do
        pending("Scott's ERB templates")
        response_body.should contain("")
      end
    end
    
    describe "with the most revenue" do
      it "should" do
        pending("Scott's ERB templates")
        #assert_have_selector "body > header > nav"
        response_body.should contain("")
      end
    end
    
  end
  
  describe "pages" do
    before(:each) do
      click_link "Pages"
    end
    
    describe "with the most tips" do
      it "should" do
        pending("Scott's ERB templates")
        response_body.should contain("")
      end
    end
    
    describe "with the most revenue" do
      it "should" do
        pending("Scott's ERB templates")
        #assert_have_selector "body > header > nav"
        response_body.should contain("")
      end
    end
    
  end
  
end