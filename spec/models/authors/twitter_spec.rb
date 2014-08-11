require 'spec_helper'

describe Authors::Twitter do
  before do
    @author = create!(:author_twitter, username:"_ugly")
    @author.stub(:send_tweet)
    # Page.any_instance.stub(:learn)
    @twitter_user = double('user', id:398095666, screen_name:'copper_is', profile_image_url:'https://pbs.twimg.com/profile_images/1303637209/nostrals.jpg')
    ::Twitter.stub(:user).and_return(@twitter_user)
  end

  describe "Should discover author from url's " do
    it "https://twitter.com/#!/nytopinion", :vcr do
      Author.find_or_create_from_url("https://twitter.com/#!/nytopinion").should be_true
    end

    it "https://twitter.com/nytopinion", :vcr do
      Author.find_or_create_from_url("https://twitter.com/nytopinion").should be_true
    end
  end

  describe '#populate_uid_and_username!' do
    before do
      @author = create!(:author_twitter, username:"copper_is")
    end

    after do
      @author.save.should be_true
      @author.populate_uid_and_username!
      @author.username.should == 'copper_is'
      @author.uid.should == '398095666'
    end

    it 'finds the uid if usenname is set', :vcr do
      @author.uid = nil
      @author.username = 'copper_is'
    end

    it 'finds the username if uid is set', :vcr do
      @author.uid = '398095666'
      @author.username = nil
    end
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      Author.provider_from_url("https://www.twitter.com/").should be_false
    end

    it "http://twitter.com/share" do
      Author.provider_from_url("http://twitter.com/share").should be_false
    end
  end

  it "should render a profile url", :vcr do
    @author.url.should == "https://twitter.com/_ugly"
  end

  it "should render a profile image", :vcr do
    @author.profile_image.should == "https://pbs.twimg.com/profile_images/1303637209/nostrals.jpg"
  end

end
