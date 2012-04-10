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
  
  context do
    before do
      @page.save
      @royalty_order = RoyaltyOrder.create
      @royalty = Royalty.new
      @royalty.amount_in_cents = 200
      @royalty.save.should be_true
      @royalty_order.royalties << @royalty
      @royalty_order.save.should be_true
      @page.royalty_orders << @royalty_order
      @page.save.should be_true
    end
    it "should provide a method for total pending royalties", :focus do
      @page.respond_to?(:total_pending_royalties_in_cents).should be_true
    end
    it "should report correct amount" do
      @page.total_pending_royalties_in_cents.should == 200
    end
  end
end
