require 'spec_helper'

describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_twitter, username:"_ugly")
    @identity.stub(:send_tweet)
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      Identity.provider_from_url("https://www.twitter.com/").should be_false
    end

    it "http://twitter.com/share" do
      Identity.provider_from_url("http://twitter.com/share").should be_false
    end
  end
end
