require "spec_helper"

describe ApplicationController do
  describe "routing" do
    it "routes to #appcache" do
      get("/appcache").should route_to("application#appcache")
    end

    it "routes to #index" do
      get("/").should route_to("application#index")
    end

  end
end
