require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before(:each) do
    @page = Page.new
    @page.description = 'test page'
  end

  it "should save if all values are acceptable" do
    @page.save.should be_true
  end

  it "should have a description" do
    @page.description = nil
    @page.save.should be_false
  end

  it "should be able to find all its associated URLs" do
    @page.save
    @page.locators << Locator.parse('http://example.com/path1')
    @page.locators << Locator.parse('http://example.com/path2')
    @page.locators << Locator.parse('http://example.com/path3')

    saved_page = Page.find(@page.id)
    saved_page.locators.size.should == 3
  end
end
