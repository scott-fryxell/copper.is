require "spec_helper"

describe PagesController do
  describe "routing" do

    it "routes to #index" do
      get("/").should route_to("pages#index")
    end
  end
end
