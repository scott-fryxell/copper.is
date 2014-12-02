describe TipsController, :type => :routing do
  describe "routing" do

    it "routes to #new" do
      expect(get("/tips/new")).to route_to("tips#new")
    end

    it "routes to #create" do
      expect(post("/tips")).to route_to("tips#create")
    end

    it "routes to #update" do
      expect(put("/tips/1")).to route_to("tips#update", id:"1")
    end

    it "routes to #destroy" do
      expect(delete("/tips/1")).to route_to("tips#destroy", id:"1")
    end

    it "routes to #given" do
      expect(get("/tips/given")).to route_to("tips#given")
    end

    it "routes to #received" do
      expect(get("/tips/received")).to route_to("tips#received")
    end

  end
end
