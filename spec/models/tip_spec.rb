require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  fixtures :roles, :users, :roles_users, :pages, :sites, :locators, :tip_bundles

  before(:each) do
    @tip = Tip.new(:tip_bundle => tip_bundles(:active_bundle),
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
end
