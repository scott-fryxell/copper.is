require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites

  describe "sites" do

    describe "with most tips report" do
      before(:each) do
        get :sites_most_tips
      end
      it "should produce a page containing a list of the sites with the most tips" do
        response.should redirect_to(sites_most_tips_url)
        assigns['sites'].should_not be_nil
      end
    end

    describe "with the most revenue report" do
      before(:each) do
        get :sites_most_revenue
      end
      it "should product a page containing a list of the sites with the most revenue" do
        response.should redirect_to(sites_most_revenue_url)
        assigns['sites'].should_not be_nil
      end
    end

  end

  describe "pages" do

    describe "with the most tips report" do
      before(:each) do
        get :pages_most_tips
      end
      it "should produce a page containing a list of the pages with the most tips" do
        response.should redirect_to(pages_most_tips_url)
        assigns['pages'].should_not be_nil
      end
    end

    describe "with the most revenue report" do
      before(:each) do
        get :pages_most_revenue
      end
      it "should produce a page containing a list of the pages with the most revenue" do
        response.should redirect_to(pages_most_revenue_url)
        assigns['pages'].should_not be_nil
      end
    end

  end

end