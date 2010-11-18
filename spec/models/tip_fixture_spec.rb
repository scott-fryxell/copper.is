require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills

  before(:each) do
    @tip = Tip.new(:tip_bundle => tip_bundles(:test_bundle),
                   :locator    => locators(:minimal),
                   :amount_in_cents => 25)
  end

  it "should always be associated with a tip bundle" do
    @tip.tip_bundle = nil
    @tip.save.should be_false
  end

  it "should always be associated with a URL" do
    @tip.locator = nil
    @tip.save.should be_false
  end

  it "should save correctly with defaults set" do
    @tip.save.should be_true
    @tip.tip_bundle.should_not be_nil
    @tip.locator.should_not be_nil
  end

  it "should have a default multiplier of 1" do
    @tip.multiplier.should == 1
  end

  it "should require a multiplier greater than 0" do
    @tip.multiplier = 0
    @tip.save.should be_false
  end

  it "should require the multiplier to be a whole number" do
    @tip.multiplier = 3.5
    @tip.save.should be_false
  end
end
