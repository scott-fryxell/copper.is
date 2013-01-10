require 'spec_helper'

describe Authors::Tumblr do

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      Author.provider_from_url("https://www.tumblr.com/").should be_false
    end
  end

  describe "Should create author from url " do
    it "http://www.tumblr.com/follow/copper-is" do
      Author.find_or_create_from_url("http://www.tumblr.com/follow/copper-is").should be_true
    end

    it "http://janebook.tumblr.com" do
      Author.find_or_create_from_url("http://janebook.tumblr.com").should be_true
    end
  end


end


