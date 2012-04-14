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
  end
  
  context 'normalization' do
    before do
      @page = Page.new url:"www.example.com"
      @page.save.should be_true
    end
    
    it "should save original url with page", :focus do
      @page.url.should == 'example.com'
      @page.original_url.should == 'www.example.com'
    end
    
    
    it "provides a normalized find by url method" do
      Page.respond_to?(:normalized_find).should be_true
    end
    
    it "provides a normalized find or create by url method" do
      Page.respond_to?(:normalized_find_or_create).should be_true
    end
    
    it "assumes http when there is a tip without scheme" do
      Page.normalized_find('example.com').id.should == @page.id 
    end
    
    it "assumes http when there is a tip with https scheme" do
      Page.normalized_find('https://example.com').id.should == @page.id 
    end
    
    it "assumes http when there is a tip with http scheme" do
      Page.normalized_find('http://example.com').id.should == @page.id 
    end
    
    it "assumes no host name when there is a tip with a 'www' hostname" do
      Page.normalized_find('http://www.example.com').id.should == @page.id 
    end
    
    it "assumes http and no host when there is a tip with no http scheme and a 'www' host" do
      Page.normalized_find('http://www.example.com').id.should == @page.id 
    end
  end
  
  context 'scopes' do
    before do
      @unauthored = Array.new(3) { FactoryGirl.create(:unauthored_page) }
      @authored = Array.new(2) { FactoryGirl.create(:authored_page) }
    end
    
    it 'has an .authored scope' do
      Page.authored.count.should == @authored.size
    end
    
    it 'has an .unauthored scope' do
      Page.unauthored.count.should == @unauthored.size
    end
  end
end
