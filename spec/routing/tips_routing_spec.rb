require "spec_helper"

describe TipsController do
  describe "routing" do

    it "routes to #new" do
      get("/tips/new").should route_to("tips#new")
    end

    it "routes to #create" do
      post("/tips").should route_to("tips#create")
    end

    it "routes to #update" do
      put("/tips/1").should route_to("tips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tips/1").should route_to("tips#destroy", :id => "1")
    end

  end
end
