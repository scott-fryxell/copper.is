describe Authorizer::Tumblr, :type => :model do

  describe '#identity_from_url' do

    context "identifiable " do
      it "http://www.tumblr.com/follow/copper-is" do
        expect(Author.find_or_create_from_url("http://www.tumblr.com/follow/copper-is")).to be_truthy
      end

      it "http://janebook.tumblr.com" do
        expect(Author.find_or_create_from_url("http://janebook.tumblr.com")).to be_truthy
      end
    end

    context "unidentifiable" do
      it "tumblr.com" do
        expect(Author.identity_from_url("https://www.tumblr.com/")).to be_falsey
      end

      it "www.tumblr.com" do
        expect(Author.identity_from_url("https://www.tumblr.com/")).to be_falsey
      end

      it "http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/" do
        expect(Author.identity_from_url("http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/")).to be_nil
      end

      it "http://www.tumblr.com/share" do
        expect(Author.identity_from_url("http://www.tumblr.com/share")).to be_nil
      end

    end

  end

end
