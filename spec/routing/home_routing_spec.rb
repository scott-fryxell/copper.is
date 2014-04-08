require "spec_helper"

describe HomeController do
  describe "routing" do

    it "routes to #index" do
      get("/").should route_to("home#index")
    end

    it "routes to #admin" do
      get("/admin").should route_to("home#admin")
    end

    it "routes to #ping" do
      get("/ping").should route_to("home#ping")
    end

    it "routes to #test" do
      get("/test").should route_to("home#test")
    end

  end
end
