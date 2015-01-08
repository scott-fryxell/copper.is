describe UsersController, :type => :routing do
  describe "routing" do

    it "routes to settings" do
      expect(get("/settings")).to route_to("users#settings")
    end

    it "routes to profile" do
      expect(get("/users/1")).to route_to("users#show", id:"1")
    end

    it "routes to #update" do
      expect(put("/users/1")).to route_to("users#update", id:"1")
    end

  end
end
