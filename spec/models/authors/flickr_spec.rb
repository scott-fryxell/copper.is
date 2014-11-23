describe Authors::Flickr, :type => :model do

  describe '#identity_from_url' do

    context "identifiable " do

      it "http://www.flickr.com/photos/floridamemory/7067827087/" do
        expect(Author.find_or_create_from_url("http://www.flickr.com/photos/floridamemory/7067827087/")).to be_truthy
      end

    end

    context "unidentifiable" do

      it "flickr.com" do
        expect(Author.identity_from_url("https://flickr.com/")).to be_falsey
      end

      it "www.flickr.com" do
        expect(Author.identity_from_url("https://www.flickr.com/")).to be_falsey
      end

      it "http://code.flickr.net/2008/10/27/counting-timing/" do
        expect(Author.identity_from_url("http://code.flickr.net/2008/10/27/counting-timing/")).to be_nil
      end

    end

  end

end
