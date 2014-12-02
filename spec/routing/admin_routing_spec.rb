describe AdminController, :type => :routing do
  describe "routing" do

    it "routes to #ping" do
      expect(get("/ping")).to route_to("admin#ping")
    end

    it "routes to #test" do
      expect(get("/test")).to route_to("admin#test")
    end

  end
end
