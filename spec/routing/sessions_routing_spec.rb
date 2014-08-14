require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes to #signout" do
      get("/signout").should route_to("sessions#destroy")
    end

    it "routes to #create" do
      get("/auth/facebook/callback").should route_to("sessions#create", provider:'facebook')
    end

    it "routes to #failure" do
      post("/auth/failure").should route_to("sessions#failure")
    end

  end
end
