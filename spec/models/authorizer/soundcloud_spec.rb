describe Authorizer::Soundcloud, :type => :model do

  describe '#identity_from_url' do

    context "identifiable " do

      it "http://soundcloud.com/snoopdogg/sets/samples-106/" do
        expect(Author.find_or_create_from_url("http://soundcloud.com/snoopdogg/sets/samples-106/")).to be_truthy
      end

      it "http://soundcloud.com/brokenbydawn" do
        expect(Author.find_or_create_from_url("http://soundcloud.com/brokenbydawn")).to be_truthy
      end

    end

    context "unidentifiable" do

      it "soundcloud.com" do
        expect(Author.identity_from_url("https://soundcloud.com/")).to be_falsey
      end

      it "www.soundcloud.com" do
        expect(Author.identity_from_url("https://www.soundcloud.com/")).to be_falsey
      end

      it "http://soundcloud.com/dashboard" do
        expect(Author.identity_from_url("http://soundcloud.com/dashboard")).to be_falsey
      end
    end

  end

end
