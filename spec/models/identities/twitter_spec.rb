require 'spec_helper'

describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_twitter, username:"_ugly")
    @identity.stub(:send_tweet)
  end

  describe '#populate_uid_and_username!' do
    it 'finds the uid if username is set' do
      @identity.uid = nil
      @identity.username = '_ugly'
    end

    it 'finds the username if uid is set' do
      @identity.uid = '26368397'
      @identity.username = nil
    end

    after do
      @identity.save.should be_true
      @identity.reload
      @identity.populate_uid_and_username!
      @identity.username.should == '_ugly'
      @identity.uid.should == '26368397'
    end
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      Identity.provider_from_url("https://www.twitter.com/").should be_false
    end

    it "http://twitter.com/share" do
      Identity.provider_from_url("http://twitter.com/share").should be_false
    end
end
