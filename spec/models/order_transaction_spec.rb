require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OrderTransaction do
  fixtures :users, :accounts, :orders, :order_transactions

  before(:each) do
    @transaction = order_transactions(:one)
  end

  it "should save when all values are acceptable" do
    @transaction.save.should be_true
  end

  it "should be able to store a serialized hash stored in the params field" do
    @transaction.params = {"a" => 100, "b" => "a string"}
    @transaction.save.should be_true
    @transaction.params.should be_an_instance_of Hash
    @x = OrderTransaction.find_by_message("this is a message")
    @x.params.should be_an_instance_of Hash
  end

  it "should be owned by an order" do
    @transaction.order.should_not be_nil
  end
end