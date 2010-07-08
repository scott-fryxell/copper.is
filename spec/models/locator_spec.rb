require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Locator do
  describe "when creating from scratch" do
    before(:each) do
      @url = Locator.new
      @url.scheme = 'http'
      @url.userinfo = 'test:test'
      @url.registry = nil
      @url.host = 'example.com'
      @url.port = 8080
      @url.path = '/home'
      @url.opaque = nil
      @url.query = 'style=minimal'
      @url.fragment = 'about'
    end

    it "should always have a scheme" do
      @url.scheme = nil
      @url.save.should be_false
    end

    it "should always have a hostname" do
      @url.host = nil
      @url.save.should be_false
    end

    it "should have a default path of '/' if saved without one" do
      @url.path = nil
      @url.save.should be_true
      @url.canonicalized.should == 'http://test:test@example.com:8080/?style=minimal#about'
    end
  end

  describe "when working with minimal correct URL" do
    before(:each) do
      @url = Locator.new
      @url.scheme = 'http'
      @url.host = 'example.com'
    end

    it "should save and be formatted correctly" do
      @url.save.should be_true
      @url.canonicalized.should == 'http://example.com/'
    end

    it "should omit the port number if the scheme is HTTP and the port is 80" do
      @url.port = 80
      @url.canonicalized.should == 'http://example.com/'
    end

    it "should include the port number if the scheme is HTTP and the port is not 80" do
      @url.scheme = 'http'
      @url.port = 8080
      @url.canonicalized.should == 'http://example.com:8080/'
    end

    it "should omit the port number if the scheme is HTTPS and the port is 443" do
      @url.scheme = 'https'
      @url.port = 443
      @url.canonicalized.should == 'https://example.com/'
    end

    it "should include the port number if the scheme is HTTPS and the port is not 443" do
      @url.scheme = 'https'
      @url.port = 8443
      @url.canonicalized.should == 'https://example.com:8443/'
    end
  end
end
