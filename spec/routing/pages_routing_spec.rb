describe PagesController, :type => :routing do

  describe "routing" do

    context "collection" do

      it "routes to #trending" do
        expect(get("/pages/trending")).to route_to("pages#trending")
      end

      it "routes to #recent" do
        expect(get("/pages/recent")).to route_to("pages#recent")
      end

      it "routes to #collection.appcache" do
        expect(get("/pages/appcache")).to route_to("pages#collection_appcache")
      end
    end

    context 'member' do
      it "routes to #update" do
        expect(put("/pages/1")).to route_to("pages#update", id:"1")
      end

      it "routes to #show" do
        expect(get("/pages/1")).to route_to("pages#show", id:"1")
      end

      it "routes to #member_appcache" do
        expect(get("/pages/1/appcache")).to route_to("pages#member_appcache", id:"1")
      end

    end

  end

end
