require 'spec_helper'

describe Identities::Tumblr do

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      Identity.provider_from_url("https://www.tumblr.com/").should be_false
    end
  end

  describe "Should discover identity from url's " do
    it "http://www.tumblr.com/follow/copper-is" do
     Identity.provider_from_url("http://www.tumblr.com/follow/copper-is").should == 'tumblr'
    end

    it "http://janebook.tumblr.com" do
     Identity.provider_from_url("http://janebook.tumblr.com").should == 'tumblr'
    end

  end


end


