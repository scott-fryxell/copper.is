describe Authorizer::Facebook, :type => :model do

  describe '#identity_from_url' do

    context 'identifiable' do
      it "from a profile" do
        expect(Author.identity_from_url('http://www.facebook.com/scott.fryxell')).to be_truthy
      end

      it "from a photo", :vcr do
        expect(Author.identity_from_url('https://www.facebook.com/photo.php?fbid=559044474113512&set=t.580281278&type=3&theater')).to be_truthy
        expect(Author.identity_from_url("https://www.facebook.com/photo.php?fbid=415648305162300&set=a.304808032912995.69593.286232048103927&type=1&theater")).to be_truthy
      end

      it "from old scheme" do
        expect(Author.identity_from_url('https://www.facebook.com/profile.php?id=1340075098')).to be_truthy
      end

      it "finds user on facebook.com via their photo, even if the photo is locked down" do
        expect(Author.identity_from_url("https://www.facebook.com/photo.php?fbid=4198406752067&set=a.2719363096900.2127501.1041690079&type=1&theater")).to be_truthy
      end

      it "finds user on facebook.com old style id" do
        expect(Author.identity_from_url("https://www.facebook.com/profile.php?id=1340075098")).to be_truthy
      end
    end

    describe "unidentifiable" do

      it "facebook.com" do
        expect(Author.identity_from_url("http://facebook.com/")).to be_nil
      end

      it "www.facebook.com" do
        expect(Author.identity_from_url("http://www.facebook.com/")).to be_nil
      end

      it "http://www.facebook.com/r.php" do
        expect(Author.identity_from_url("http://www.facebook.com/r.php?next=https%253A%252F%252Fwww.facebook.com%252Fhome.php&locale=en_US")).to be_nil
      end

      it "https://www.facebook.com/login.php" do
        expect(Author.identity_from_url("https://www.facebook.com/login.php?next=https%3A%2F%2Fwww.facebook.com%2Fhome.php")).to be_nil
      end

      it "http://www.facebook.com/mobile/" do
        expect(Author.identity_from_url("http://www.facebook.com/mobile/?ref=pf")).to be_nil
      end

      it "http://www.facebook.com/find-friends" do
        expect(Author.identity_from_url("http://www.facebook.com/find-friends?ref=pf")).to be_nil
      end

      it "http://www.facebook.com/badges/" do
        expect(Author.identity_from_url("http://www.facebook.com/badges/?ref=pf")).to be_nil
      end

      it "http://www.facebook.com/directory/" do
        expect(Author.identity_from_url("http://www.facebook.com/directory/people/")).to be_nil
      end

      it "http://www.facebook.com/appcenter/" do
        expect(Author.identity_from_url("http://www.facebook.com/appcenter/category/games/?ref=pf")).to be_nil
      end

      it "https://www.facebook.com/apps/application.php?id=265853386838821" do
        expect(Author.identity_from_url("https://www.facebook.com/apps/application.php?id=265853386838821")).to be_nil
      end

    end

  end

  describe '#populate_uid_and_username!' do
    subject(:author) {create!(:author_facebook, username:"scott.fryxell")}

    after do
      author.populate_uid_and_username!
      expect(author.username).to eq('scott.fryxell')
      expect(author.uid).to eq('580281278')
    end

    it 'finds the uid if usenname is set', :vcr do
      author.uid = nil
      author.username = 'scott.fryxell'
    end

    it 'finds the username if uid is set', :vcr do
      author.uid = '580281278'
      author.username = nil
    end
  end

  describe '#url' do

    context 'with username' do
      subject(:author) {create!(:author_facebook, username:"scott.fryxell", id:nil)}

      it "should return the users profile url", :vcr do
        expect(author.url).to eq("https://www.facebook.com/scott.fryxell")
      end

    end

    context 'with id' do
      subject(:author) { create!(:author_facebook, uid:'580281278', username:nil) }

      it "return url", :vcr do
        expect(author.url).to eq("https://www.facebook.com/scott.fryxell")
      end

    end

  end

  describe '#determine_image' do

    context 'with username' do
      subject(:author) {create!(:author_facebook, username:"scott.fryxell", id:nil)}

      it "return image", :vcr do
        expect(author.determine_image).to eq("https://graph.facebook.com/scott.fryxell/picture?type=square")
      end

    end

    context 'with id' do
      subject(:author) { create!(:author_facebook, uid:'580281278', username:nil) }

      it "returns image", :vcr do
        expect(author.determine_image).to eq("https://graph.facebook.com/scott.fryxell/picture?type=square")
      end

    end

  end


end
