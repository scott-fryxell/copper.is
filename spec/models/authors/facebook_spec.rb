require 'spec_helper'

describe Authors::Facebook, :type => :model do

  describe "Should find identity's from facebook url's" do
    it "finds user on facebook.com" do
      expect(Author.authorizer_from_url("http://www.facebook.com/scott.fryxell")).to be_truthy
    end

    it "finds user on facebook.com via their photo" do
      expect(Author.authorizer_from_url("https://www.facebook.com/photo.php?fbid=415648305162300&set=a.304808032912995.69593.286232048103927&type=1&theater")).to be_truthy
    end

    it "finds user on facebook.com via their photo, even if the photo is locked down" do
      expect(Author.authorizer_from_url("https://www.facebook.com/photo.php?fbid=4198406752067&set=a.2719363096900.2127501.1041690079&type=1&theater")).to be_truthy
    end

    it "finds user on facebook.com old style id" do
      expect(Author.authorizer_from_url("https://www.facebook.com/profile.php?id=1340075098")).to be_truthy
    end
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.facebook.com/" do
      expect(Author.authorizer_from_url("https://www.facebook.com/")).to be_falsey
    end

    it "http://www.facebook.com/r.php" do
      expect(Author.authorizer_from_url("http://www.facebook.com/r.php?next=https%253A%252F%252Fwww.facebook.com%252Fhome.php&locale=en_US")).to be_falsey
    end

    it "https://www.facebook.com/login.php" do
      expect(Author.authorizer_from_url("https://www.facebook.com/login.php?next=https%3A%2F%2Fwww.facebook.com%2Fhome.php")).to be_falsey
    end

    it "http://www.facebook.com/mobile/" do
      expect(Author.authorizer_from_url("http://www.facebook.com/mobile/?ref=pf")).to be_falsey
    end

    it "http://www.facebook.com/find-friends" do
      expect(Author.authorizer_from_url("http://www.facebook.com/find-friends?ref=pf")).to be_falsey
    end

    it "http://www.facebook.com/badges/" do
      expect(Author.authorizer_from_url("http://www.facebook.com/badges/?ref=pf")).to be_falsey
    end

    it "http://www.facebook.com/directory/" do
      expect(Author.authorizer_from_url("http://www.facebook.com/directory/people/")).to be_falsey
    end

    it "http://www.facebook.com/appcenter/" do
      expect(Author.authorizer_from_url("http://www.facebook.com/appcenter/category/games/?ref=pf")).to be_falsey
    end
  end

  describe '#populate_uid_and_username!' do
    before do
      @author = create!(:author_facebook, username:"scott.fryxell")
    end

    after do
      expect(@author.save).to be_truthy
      @author.populate_uid_and_username!
      expect(@author.username).to eq('scott.fryxell')
      expect(@author.uid).to eq('580281278')
    end

    it 'finds the uid if usenname is set', :vcr do
      @author.uid = nil
      @author.username = 'scott.fryxell'
    end

    it 'finds the username if uid is set', :vcr do
      @author.uid = '580281278'
      @author.username = nil
    end
  end

  describe 'asset paths by username' do
    before do
      @author = create!(:author_facebook, username:"scott.fryxell")
    end

    it "should return the users profile_img", :vcr do
      expect(@author.profile_image).to eq("https://graph.facebook.com/scott.fryxell/picture?type=square")
    end

    it "should return the users profile url", :vcr do
      expect(@author.url).to eq("https://www.facebook.com/scott.fryxell")
    end

  end

  describe 'asset paths by uid' do
    before do
      @author = create!(:author_facebook, uid:'580281278')
    end

    it "should return the users profile_img", :broken do
      expect(@author.profile_image).to eq("https://graph.facebook.com/scott.fryxell/picture?type=square")
    end

    it "should return the users profile url", :broken do
      expect(@author.url).to eq("https://www.facebook.com/scott.fryxell")
    end

  end


end
