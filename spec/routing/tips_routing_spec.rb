require "spec_helper"

describe TipsController do
  describe "routing" do

    it "routes to #index" do
      get("/t").should route_to("tips#index")
    end

    it "routes to #new" do
      get("/t/new").should route_to("tips#new")
    end

    it "routes to #show" do
      get("/t/1").should route_to("tips#show", :id => "1")
    end

    it "routes to #edit" do
      get("/t/1/edit").should route_to("tips#edit", :id => "1")
    end

    it "routes to #create" do
      post("/t").should route_to("tips#create")
    end

    it "routes to #update" do
      put("/t/1").should route_to("tips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/t/1").should route_to("tips#destroy", :id => "1")
    end

  end
end
