require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
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
    @page.tips_earned.should_not be_nil
  end

  it "should return a list of the most tipped pages" do
    @pages_with_tips = Page.most_tips
    @pages_with_tips.should_not be_nil
  end

  it "should respond when asked how much revenue it has earned" do
    @page.revenue_earned.should_not be_nil
  end

  it "should return a list of the pages with the most revenue" do
    @pages_with_revenue = Page.most_revenue
    @pages_with_revenue.should_not be_nil
  end

end
