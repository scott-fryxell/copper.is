require "spec_helper"

describe IdentitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/i").should route_to("identities#index")
    end

    it "routes to #new" do
      get("/i/new").should route_to("identities#new")
    end

    it "routes to #show" do
      get("/i/1").should route_to("identities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/i/1/edit").should route_to("identities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/i").should route_to("identities#create")
    end

    it "routes to #update" do
      put("/i/1").should route_to("identities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/i/1").should route_to("identities#destroy", :id => "1")
    end

  end
end
