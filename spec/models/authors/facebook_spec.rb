require 'spec_helper'

describe Authors::Facebook do

  describe "Should find idetity's from facebook url's" do
    it "finds user on facebook.com" do
      Author.provider_from_url("http://www.facebook.com/scott.fryxell").should be_true
    end

    it "finds user on facebook.com via their photo" do
      Author.provider_from_url("https://www.facebook.com/photo.php?fbid=415648305162300&set=a.304808032912995.69593.286232048103927&type=1&theater").should be_true
    end

    it "finds user on facebook.com via their photo, even if the photo is locked down" do
      Author.provider_from_url("https://www.facebook.com/photo.php?fbid=4198406752067&set=a.2719363096900.2127501.1041690079&type=1&theater").should be_true
    end

    it "finds user on facebook.com old style id" do
      Author.provider_from_url("https://www.facebook.com/profile.php?id=1340075098").should be_true
    end
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.facebook.com/" do
      Author.provider_from_url("https://www.facebook.com/").should be_false
    end

    it "http://www.facebook.com/r.php" do
      Author.provider_from_url("http://www.facebook.com/r.php?next=https%253A%252F%252Fwww.facebook.com%252Fhome.php&locale=en_US").should be_false
    end

    it "https://www.facebook.com/login.php" do
      Author.provider_from_url("https://www.facebook.com/login.php?next=https%3A%2F%2Fwww.facebook.com%2Fhome.php").should be_false
    end

    it "http://www.facebook.com/mobile/" do
      Author.provider_from_url("http://www.facebook.com/mobile/?ref=pf").should be_false
    end

    it "http://www.facebook.com/find-friends" do
      Author.provider_from_url("http://www.facebook.com/find-friends?ref=pf").should be_false
    end

    it "http://www.facebook.com/badges/" do
      Author.provider_from_url("http://www.facebook.com/badges/?ref=pf").should be_false
    end

    it "http://www.facebook.com/directory/" do
      Author.provider_from_url("http://www.facebook.com/directory/people/").should be_false
    end

    it "http://www.facebook.com/appcenter/" do
      Author.provider_from_url("http://www.facebook.com/appcenter/category/games/?ref=pf").should be_false
    end
  end

  describe '#populate_uid_and_username!' do
    before do
      @author = create!(:author_facebook, username:"scott.fryxell")
    end

    after do
      @author.save.should be_true
      @author.populate_uid_and_username!
      @author.username.should == 'scott.fryxell'
      @author.uid.should == '580281278'
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
      @author.profile_image.should == "https://graph.facebook.com/scott.fryxell/picture?type=square"
    end

    it "should return the users profile url", :vcr do
      @author.url.should == "https://www.facebook.com/scott.fryxell"
    end

  end

  describe 'asset paths by uid' do
    before do
      @author = create!(:author_facebook, uid:'580281278')
    end

    it "should return the users profile_img" do pending
      @author.profile_image.should == "https://graph.facebook.com/scott.fryxell/picture?type=square"
    end

    it "should return the users profile url" do pending
      @author.url.should == "https://www.facebook.com/scott.fryxell"
    end

  end


end
