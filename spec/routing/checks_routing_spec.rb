require "spec_helper"

describe ChecksController do
  describe "routing" do

    it "routes to #index" do
      get("/checks").should route_to("checks#index")
    end

    it "routes to #show" do
      get("/checks/1").should route_to("checks#show", :id => "1")
    end

  end
end
