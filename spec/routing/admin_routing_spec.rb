require "spec_helper"

describe AdminController do
  describe "routing" do

    it "routes to #ping" do
      get("/ping").should route_to("admin#ping")
    end

    it "routes to #test" do
      get("/test").should route_to("admin#test")
    end

  end
end
