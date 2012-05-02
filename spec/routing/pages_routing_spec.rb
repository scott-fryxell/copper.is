require "spec_helper"

describe PagesController do
  describe "routing" do

    it "routes to #index" do
      get("/p").should route_to("pages#index")
    end

    it "routes to #new" do
      get("/p/new").should route_to("pages#new")
    end

    it "routes to #show" do
      get("/p/1").should route_to("pages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/p/1/edit").should route_to("pages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/p").should route_to("pages#create")
    end

    it "routes to #update" do
      put("/p/1").should route_to("pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/p/1").should route_to("pages#destroy", :id => "1")
    end

  end
end
