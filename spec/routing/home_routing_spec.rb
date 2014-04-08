require "spec_helper"

describe HomeController do
  describe "routing" do

    it "routes to #index" do
      get("/").should route_to("home#index")
    end

    it "routes to #author" do
      get("/author").should route_to("home#author")
    end

    it "routes to #ping" do
      get("/ping").should route_to("home#ping")
    end

    it "routes to #test" do
      get("/test").should route_to("home#test")
    end

  end
end
