require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #index" do
      get("/u").should route_to("users#index")
    end

    it "routes to #new" do
      get("/u/new").should route_to("users#new")
    end

    it "routes to #show" do
      get("/u/1").should route_to("users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/u/1/edit").should route_to("users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/u").should route_to("users#create")
    end

    it "routes to #update" do
      put("/u/1").should route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/u/1").should route_to("users#destroy", :id => "1")
    end

  end
end
