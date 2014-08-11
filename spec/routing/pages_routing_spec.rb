require "spec_helper"

describe PagesController do

  describe "routing" do

    context "collection" do

      it "routes to #trending" do
        get("/pages/trending").should route_to("pages#trending")
      end

      it "routes to #recent" do
        get("/pages/recent").should route_to("pages#recent")
      end

      it "routes to #collection.appcache" do
        get("/pages/appcache").should route_to("pages#collection_appcache")
      end
    end

    context 'member' do
      it "routes to #update" do
        put("/pages/1").should route_to("pages#update", id:"1")
      end

      it "routes to #show" do
        get("/pages/1").should route_to("pages#show", id:"1")
      end

      it "routes to #member_appcache" do
        get("/pages/1/appcache").should route_to("pages#member_appcache", id:"1")
      end

    end

  end

end
