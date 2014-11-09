require 'spec_helper'

describe Authors::Tumblr, :type => :model do
  before do
    mock_page
  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.twitter.com/" do
      expect(Author.authorizer_from_url("https://www.tumblr.com/")).to be_falsey
    end
  end

  describe "Should create author from url " do
    it "http://www.tumblr.com/follow/copper-is" do
      expect(Author.find_or_create_from_url("http://www.tumblr.com/follow/copper-is")).to be_truthy
    end

    it "http://janebook.tumblr.com" do
      expect(Author.find_or_create_from_url("http://janebook.tumblr.com")).to be_truthy
    end
  end


end


