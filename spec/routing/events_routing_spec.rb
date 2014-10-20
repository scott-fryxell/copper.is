require "spec_helper"

describe EventsController do


  describe "routing" do

    # TODO: how do you write this test as a concern?
    it "routes to #publisher" do
      get("/events").should route_to("events#publisher")
    end

  end
end
