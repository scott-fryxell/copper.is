require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  context do
    before(:each) do
      @page = Page.new
      @page.url = 'http://example.com/path1'
    end

    it "should save with a valid url" do
      @page.save.should be_true
    end

    it "should have a title" do
      @page.title = 'this is a page'
      @page.save.should be_true
    end

    it "should not save with an invalid url" do
      @page.url = '666'
      @page.save.should be_false
    end
    
    it "should allow tips to be added" do
      tip = FactoryGirl.create(:tip) 
      @page.tips << tip
      @page.save.should be_true
    end
    
    it "should assume http when there is a tip without schema" do
      @page.url = "example.com/path/to/url"
      @page.save.should be_true
    end
    
  end
end