require "spec_helper"

describe EventsController do


  describe "routing" do

    it "routes to #domain" do
      get("/events").should route_to("events#domain")
    end

    # TODO: how do you write this test as a concern?
    it "routes to #collection" do
      get("/events").should route_to("events#collection")
    end

    # TODO: how do you write this test as a concern?
    it "routes to #member" do
      get("/events/1").should route_to("events#member")
    end

  end
end
