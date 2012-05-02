require "spec_helper"

describe ChecksController do
  describe "routing" do

    it "routes to #index" do
      get("/c").should route_to("checks#index")
    end

    it "routes to #new" do
      get("/c/new").should route_to("checks#new")
    end

    it "routes to #show" do
      get("/c/1").should route_to("checks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/c/1/edit").should route_to("checks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/c").should route_to("checks#create")
    end

    it "routes to #update" do
      put("/c/1").should route_to("checks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/c/1").should route_to("checks#destroy", :id => "1")
    end

  end
end
