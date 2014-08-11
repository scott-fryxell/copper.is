require "spec_helper"

describe ApplicationController do
  describe "routing" do
    it "routes to #appcache" do
      get("/appcache").should route_to("application#appcache")
      get("/").should route_to("application#index")
    end
  end
end
