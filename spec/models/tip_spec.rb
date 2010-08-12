require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  fixtures :users, :roles_users, :tip_bundles, :addresses, :accounts, :transactions, :refills

  before(:each) do
    @uri = 'http://www.example.com/page/content.html'
    @current_user = users(:active)
  end

  it "should save if all values are acceptable" do
    @tip = Tip.build(@current_user, @uri)
    @tip.save.should be_true
  end

  it "should check if an entry for a page already exists" do
    @tip = Tip.build(@current_user, @uri)
    @tip.save.should be_true
    @tip2 = Tip.build(@current_user, @uri)
    @tip2.save.should be_true
    @tip.locator.page.should == @tip2.locator.page
  end

  it "should check if an entry for a locator already exists" do
    @tip = Tip.build(@current_user, @uri)
    @tip.save.should be_true
    @tip2 = Tip.build(@current_user, @uri)
    @tip2.save.should be_true
    @tip.locator.should == @tip2.locator
  end

  it "should create a new entry for a page if one doesn't exist" do
    Page.find_by_description('http://somenewpage.com').should be_nil
    @tip = Tip.build(@current_user, 'http://somenewpage.com')
    @tip.save.should be_true
    Page.find_by_description('http://somenewpage.com').should_not be_nil
  end

end