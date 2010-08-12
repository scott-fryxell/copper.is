require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  fixtures :users, :accounts, :orders

  before(:each) do
    # @order = orders(:one)
    @order = Order.new
    @order.ip_address = "127.0.0.1"
    @order.amount_in_cents = 1000
    @order.account = accounts(:simple)
  end

  it "should save when all values are acceptable" do
    @order.save.should be_true
  end

  it "should have an IP address" do
    @order.ip_address = nil
    @order.save.should be_false
  end

  it "should have a valid IP address" do
    @order.ip_address = "foobar"
    @order.save.should be_false
    @order.ip_address = "1.1.1"
    @order.save.should be_false
    @order.ip_address = "0.0.0.01"
    @order.save.should be_false
    @order.ip_address = "0.0.0.0.0"
    @order.save.should be_false
  end

  it "should have an account" do
    @order.account = nil
    @order.save.should be_false
  end

  it "should have an account_id that references a valid account object" do
    @order.account = nil
    @order.account_id = -1
    @order.save.should be_false
  end

  it "should have an amount" do
    @order.amount_in_cents = nil
    @order.save.should be_false
  end

  it "should have an integer for the amount" do
    @order.amount_in_cents = "Larry David"
    @order.save.should be_false
  end

end