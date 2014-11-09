require "spec_helper"

describe EventsController, :type => :routing do


  describe "routing" do

    # TODO: how do you write this test as a concern?
    it "routes to #publisher" do
      expect(get("/events")).to route_to("events#publisher")
    end

  end
end
