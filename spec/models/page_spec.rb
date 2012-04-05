require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  fixtures :users
  before(:each) do
    @page = Page.new
    @page.description = 'http://example.com/path1'
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
    @page.locators << Locator.parse('http://example.com/path1')
    @page.locators << Locator.parse('http://example.com/path1')

    saved_page = Page.find(@page.id)
    saved_page.locators.size.should == 3
  end

  it "should respond when asked how many tips it has received" do
    @page.tips.count.should_not be_nil
  end

  it "should respond when asked how much revenue it has earned" do
    @page.revenue_earned.should_not be_nil
  end

  it "should return the primary locator for a page" do
    @page.save.should be_true
    @page.locators << Locator.parse('http://example.com/path1')
    @page.primary_locator.should_not be_nil
  end
  
  it "should allow having one author" do
    @page.author = users(:a_developer)
    @page.save.should be_true
  end
end
