require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Locator do
  describe "when creating from scratch" do
    before(:each) do
      @url = Locator.new
      @url.scheme = 'http'
      @url.userinfo = 'test:test'
      @url.registry = nil
      @url.site = Site.find_or_create_by_fqdn('example.com')
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
      @url.site = nil
      @url.save.should be_false
    end

    it "should have a default path of '/' if saved without one" do
      @url.path = nil
      @url.save.should be_true
      @url.canonicalized.should == 'http://test:test@example.com:8080/?style=minimal#about'
    end
  end

  describe "when parsing a URL string into a new object" do
    describe "when parsing http://example.com" do
      before(:each) do
        @locator = Locator.parse('http://example.com')
      end

      it "should see the scheme as 'http'" do
        @locator.scheme.should == 'http'
      end

      it "should see the host as 'example.com'" do
        @locator.site.fqdn.should == 'example.com'
      end

      it "should see the port as (by default) 80" do
        @locator.port.should == 80
      end

      it "should have a nil path" do
        @locator.path.should be_nil
      end

      it "should save without error" do
        @locator.save.should be_true
      end
    end

    describe "when parsing http://example.com/test" do
      before(:each) do
        @locator = Locator.parse('http://example.com/test')
      end

      it "should see the scheme as 'http'" do
        @locator.scheme.should == 'http'
      end

      it "should see the host as 'example.com'" do
        @locator.site.fqdn.should == 'example.com'
      end

      it "should see the port as (by default) 80" do
        @locator.port.should == 80
      end

      it "should have a path of '/test'" do
        @locator.path.should == '/test'
      end

      it "should have a nil fragment" do
        @locator.fragment.should be_nil
      end

      it "should save without error" do
        @locator.save.should be_true
      end
    end

    describe "when parsing ftp://thomas.loc.gov:244/00index" do
      before(:each) do
        @locator = Locator.parse('ftp://thomas.loc.gov:244/00index')
      end

      it "should see the scheme as 'ftp'" do
        @locator.scheme.should == 'ftp'
      end

      it "should see the host as 'thomas.loc.gov'" do
        @locator.site.fqdn.should == 'thomas.loc.gov'
      end

      it "should see the port as (by default) 22" do
        @locator.port.should == 244
      end

      it "should have a path of '00index'" do
        @locator.path.should == '00index'
      end

      it "should have a nil query" do
        @locator.query.should be_nil
      end

      it "should save without error" do
        @locator.save.should be_true
      end
    end

    describe "when parsing https://scott:awsumpasswud@weave.us/test?notreally=yeah#justkiddin" do
      before(:each) do
        @locator = Locator.parse('https://scott:awsumpasswud@weave.us/test?notreally=yeah#justkiddin')
      end

      it "should see the scheme as 'https'" do
        @locator.scheme.should == 'https'
      end

      it "should have userinfo of 'scott:awsumpasswud'" do
        @locator.userinfo.should == 'scott:awsumpasswud'
      end

      it "should see the host as 'weave.us'" do
        @locator.site.fqdn.should == 'weave.us'
      end

      it "should see the port as (by default) 443" do
        @locator.port.should == 443
      end

      it "should have a path of '/test'" do
        @locator.path.should == '/test'
      end

      it "should have a query of 'notreally=yeah'" do
        @locator.query.should == 'notreally=yeah'
      end

      it "should have a fragment of 'justkiddin'" do
        @locator.fragment.should == 'justkiddin'
      end

      it "should save without error" do
        @locator.save.should be_true
      end
    end
  end

  describe "when working with minimal correct URL" do
    before(:each) do
      @url = Locator.new
      @url.scheme = 'http'
      @url.site = Site.find_or_create_by_fqdn('example.com')
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

  it "should only create a single Site for each fully-qualified domain name" do
    url1 = Locator.parse('http://example.com/path1')
    url1.save.should be_true

    url2 = Locator.parse('http://example.com/path2')
    url2.save.should be_true

    url1.site.should == url2.site
  end
end
