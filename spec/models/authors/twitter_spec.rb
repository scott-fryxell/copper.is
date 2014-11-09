require 'spec_helper'

describe Authors::Twitter, :type => :model do
  before do
    @author = create!(:author_twitter, username:"_ugly")
    allow(@author).to receive(:send_tweet)
    # Page.any_instance.stub(:learn)
    @twitter_user = double('user', id:398095666, screen_name:'copper_is', profile_image_url:'https://pbs.twimg.com/profile_images/1303637209/nostrals.jpg')
    allow(::Twitter).to receive(:user).and_return(@twitter_user)
  end

  describe "Should discover author from url's " do
    it "https://twitter.com/#!/nytopinion", :vcr do
      expect(Author.find_or_create_from_url("https://twitter.com/#!/nytopinion")).to be_truthy
    end

    it "https://twitter.com/nytopinion", :vcr do
      expect(Author.find_or_create_from_url("https://twitter.com/nytopinion")).to be_truthy
    end
  end

  describe '#populate_uid_and_username!' do
    before do
      @author = create!(:author_twitter, username:"copper_is")
    end

    after do
      expect(@author.save).to be_truthy
      @author.populate_uid_and_username!
      expect(@author.username).to eq('copper_is')
      expect(@author.uid).to eq('398095666')
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
      expect(Author.authorizer_from_url("https://www.twitter.com/")).to be_falsey
    end

    it "http://twitter.com/share" do
      expect(Author.authorizer_from_url("http://twitter.com/share")).to be_falsey
    end
  end

  it "should render a profile url", :vcr do
    expect(@author.url).to eq("https://twitter.com/_ugly")
  end

  it "should render a profile image", :vcr do
    expect(@author.profile_image).to eq("https://pbs.twimg.com/profile_images/1303637209/nostrals.jpg")
  end

end
