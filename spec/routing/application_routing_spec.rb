describe ApplicationController, :type => :routing do
  describe "routing" do
    it "routes to #appcache" do
      expect(get("/appcache")).to route_to("application#appcache")
    end

    it "routes to #index" do
      expect(get("/")).to route_to("application#index")
    end

  end
end
