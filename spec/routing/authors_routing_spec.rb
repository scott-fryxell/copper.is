require "spec_helper"

describe AuthorsController, :type => :routing do
  describe "routing" do

    it "routes to #settings" do
      expect(get("/authorizations")).to route_to("authors#settings")
    end

    it "routes to #enquire" do
      expect(get("/facebook/scott.fryxell")).to route_to("authors#enquire", provider:'facebook', username:'scott.fryxell')
    end

  end
end
