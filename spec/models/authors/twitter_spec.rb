require 'spec_helper'

describe Authors::Twitter do
  before do
    @author = create!(:author_twitter, username:"_ugly")
    @author.stub(:send_tweet)
  end

  describe "Should discover author from url's " do
    it "https://twitter.com/#!/nytopinion", :vcr do
      Author.find_or_create_from_url("https://twitter.com/#!/nytopinion").should be_true
    end

    it "https://twitter.com/nytopinion", :vcr do
      Author.find_or_create_from_url("https://twitter.com/nytopinion").should be_true
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

end
