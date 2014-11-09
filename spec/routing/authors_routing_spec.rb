require "spec_helper"

describe AuthorsController, :type => :routing do
  describe "routing" do

    it "routes to #settings" do
      expect(get("/my/authorizations")).to route_to("authors#settings")
    end

    it "routes to #claim_facebook_pages" do
      expect(get("/authors/1/claim_facebook_pages")).to route_to("authors#claim_facebook_pages", id:'1')
    end

    it "routes to #authorize_facebook_privelege" do
      expect(get("/authors/1/authorize_facebook_privelege")).to route_to("authors#authorize_facebook_privelege", id:'1')
    end

    it "routes to #can_post_to_facebook" do
      expect(get("/authors/1/can_post_to_facebook")).to route_to("authors#can_post_to_facebook", id:'1')
    end

    it "routes to #can_view_facebook_pages" do
      expect(get("/authors/1/can_view_facebook_pages")).to route_to("authors#can_view_facebook_pages", id:'1')
    end

  end
end
