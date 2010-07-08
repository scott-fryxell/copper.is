require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  fixtures :roles_users, :users, :addresses, :accounts

  before(:each) do
    @transaction = Transaction.new
    @transaction.account = accounts(:simple)
    @transaction.amount_in_cents = 10_70
  end

  it "should save if all values are acceptable" do
    @transaction.save.should be_true
  end

  it "should have an account" do
    @transaction.account = nil
    @transaction.save.should be_false
  end

  it "should have a cash value" do
    @transaction.amount_in_cents = nil
    @transaction.save.should be_false
  end

  it "should always have a cash value in whole cents" do
    @transaction.amount_in_cents = 10_70.75
    @transaction.save.should be_false
  end

  it "should always have a cash value greater than 0" do
    @transaction.amount_in_cents = 0
    @transaction.save.should be_false

    @transaction.amount_in_cents = -10_70
    @transaction.save.should be_false
  end
end
