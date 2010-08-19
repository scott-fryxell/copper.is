require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  fixtures :users, :accounts, :orders

  before(:each) do
    @order = Order.new
    @order.ip_address = "127.0.0.1"
    @order.amount_in_cents = 2500
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
    @order.errors.on(:ip_address).should == "not a valid IP address"
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

  describe "purchase sequence" do

    it "should have a purchase method that succeeds when the order is valid" do
      @order.save
      @order.purchase.should be_true
      @order.order_transactions.should_not be_nil
    end

    it "should have a method that creates a new payment, fee, and refill when the purchase goes through" do
      # TODO - when BogusGateway is fixed do @order.purchase inside this test as well
      @order.save
      @order.transaction.should be_nil
      @order.trigger_payment_refill_fee
      @order.transaction.should_not be_nil
      @order.transaction.fee.should_not be_nil
      @order.transaction.refill.should_not be_nil
    end

    it "should have a method that saves, purchases, and creates the payment/refill/fee all at once" do
      @order.place_order.should be_true
      # @order.transaction.should_not be_nil
      # @order.transaction.fee.should_not be_nil
      # @order.transaction.refill.should_not be_nil
    end
  end
end