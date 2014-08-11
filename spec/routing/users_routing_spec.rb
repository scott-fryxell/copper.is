require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to settings" do
      get("/settings").should route_to("users#settings")
    end

    it "routes to profile" do
      get("/users/1").should route_to("users#show", id:"1")
    end

    it "routes to #update" do
      put("/users/1").should route_to("users#update", id:"1")
    end

  end
end
