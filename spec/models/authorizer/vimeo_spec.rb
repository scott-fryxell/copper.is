describe Authorizer::Vimeo, :type => :model do

  describe '#identity_from_url' do

    context "identifiable " do

      it "http://vimeo.com/31453929", :vcr do
        expect(identity = Author.find_or_create_from_url("http://vimeo.com/31453929")).to be_truthy
        expect(identity.username).to eq('littlecave')
        expect(identity.uid).to eq('970884')
      end

    end

    context "unidentifiable" do


      it "vimeo.com", :vcr do
        expect(Author.identity_from_url("https://vimeo.com/")).to be_falsey
      end

      it "www.vimeo.com", :vcr do
        expect(Author.identity_from_url("https://www.vimeo.com/")).to be_falsey
      end


      it "http://vimeo.com/groups/waza2012/videos/49720072", :vcr do
        expect(Author.identity_from_url("http://vimeo.com/groups/waza2012/videos/49720072")).to be_nil
      end

    end

  end

end
