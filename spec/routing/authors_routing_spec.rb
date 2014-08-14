require "spec_helper"

describe AuthorsController do
  describe "routing" do

    it "routes to #settings" do
      get("/my/authorizations").should route_to("authors#settings")
    end

    it "routes to #claim_facebook_pages" do
      get("/authors/1/claim_facebook_pages").should route_to("authors#claim_facebook_pages", id:'1')
    end

    it "routes to #authorize_facebook_privelege" do
      get("/authors/1/authorize_facebook_privelege").should route_to("authors#authorize_facebook_privelege", id:'1')
    end

    it "routes to #can_post_to_facebook" do
      get("/authors/1/can_post_to_facebook").should route_to("authors#can_post_to_facebook", id:'1')
    end

    it "routes to #can_view_facebook_pages" do
      get("/authors/1/can_view_facebook_pages").should route_to("authors#can_view_facebook_pages", id:'1')
    end

  end
end
