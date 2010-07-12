require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fee do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions

  before(:each) do
    @fee = Fee.new
    @fee.transaction = transactions(:first)
    @fee.amount_in_cents = 70
  end

  it "should save if all values are acceptable" do
    @fee.save.should be_true
  end

  it "should be associated with a transaction" do
    @fee.transaction = nil
    @fee.save.should be_false
  end

  it "should have a cash value" do
    @fee.amount_in_cents = nil
    @fee.save.should be_false
  end

  it "should have a cash value in whole cents" do
    @fee.amount_in_cents = 10_70.75
    @fee.save.should be_false
  end

  it "should have a cash value greater than 0" do
    @fee.amount_in_cents = 0
    @fee.save.should be_false

    @fee.amount_in_cents = -10_70
    @fee.save.should be_false
  end
end
