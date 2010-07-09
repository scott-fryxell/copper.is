require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Refill do
  fixtures :roles_users, :users, :tip_bundles, :addresses, :accounts, :transactions

  before(:each) do
    @refill = Refill.new
    @refill.amount_in_cents = 10_00
    @refill.transaction     = transactions(:first)
    @refill.tip_bundle      = tip_bundles(:test)
  end

  it "should save if all values are acceptable" do
    @refill.save.should be_true
  end

  it "should be associated with a tip bundle" do
    @refill.tip_bundle = nil
    @refill.save.should be_false
  end

  it "should be associated with a transaction" do
    @refill.transaction = nil
    @refill.save.should be_false
  end

  it "should have a cash value" do
    @refill.amount_in_cents = nil
    @refill.save.should be_false
  end

  it "should have a cash value in whole cents" do
    @refill.amount_in_cents = 10_70.75
    @refill.save.should be_false
  end

  it "should have a cash value greater than 0" do
    @refill.amount_in_cents = 0
    @refill.save.should be_false

    @refill.amount_in_cents = -10_70
    @refill.save.should be_false
  end
end
