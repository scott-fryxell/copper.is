describe SessionsController, :type => :routing do
  describe "routing" do

    it "routes to #signout" do
      expect(get("/signout")).to route_to("sessions#destroy")
    end

    it "routes to #create" do
      expect(get("/auth/facebook/callback")).to route_to("sessions#create", provider:'facebook')
    end

    it "routes to #failure" do
      expect(get("/auth/failure")).to route_to("sessions#failure")
    end

  end
end
