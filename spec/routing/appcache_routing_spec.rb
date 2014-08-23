require "spec_helper"

describe AppcacheController do
  describe "routing" do

    it "routes to #index" do
      get("/events").should route_to("appcache#index")
    end

  end
end
