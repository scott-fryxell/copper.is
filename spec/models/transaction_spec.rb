require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  fixtures :users, :roles_users, :addresses, :accounts

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

  describe "when splitting transactions into fees and refils" do
    before(:each) do
      @transaction.save
    end

    it "should not validate the split if both the fee and the refill are missing" do
      @transaction.should_not be_valid_split
    end

    it "should not validate the split if the fee is missing" do
      @transaction.refill = Refill.create(:transaction => @transaction, :amount_in_cents => 10_00)
      @transaction.should_not be_valid_split
    end

    it "should not validate the split if the refill is missing" do
      @transaction.fee = Fee.create(:transaction => @transaction, :amount_in_cents => 70)
      @transaction.should_not be_valid_split
    end

    it "should validate the split if amounts match" do
      @transaction.fee = Fee.create(:transaction => @transaction, :amount_in_cents => 70)
      @transaction.refill = Refill.create(:transaction => @transaction, :amount_in_cents => 10_00)
      @transaction.should be_valid_split
    end

    it "should not validate the split if amounts don't match" do
      @transaction.fee = Fee.create(:transaction => @transaction, :amount_in_cents => 60)
      @transaction.refill = Refill.create(:transaction => @transaction, :amount_in_cents => 10_00)
      @transaction.should_not be_valid_split
    end
  end

  describe "when updating the transaction" do
    before(:each) do
      @transaction.save
    end

    it "should save if fee and refill are present" do
      @transaction.fee = Fee.create(:transaction => @transaction, :amount_in_cents => 70)
      @transaction.refill = Refill.create(:transaction => @transaction, :amount_in_cents => 10_00)
      @transaction.save.should be_true
    end

    it "should fail to save if fee is missing" do
      @transaction.refill = Refill.create(:transaction => @transaction, :amount_in_cents => 10_00)
      @transaction.save.should be_false
    end

    it "should fail to save if refill is missing" do
      @transaction.fee = Fee.create(:transaction => @transaction, :amount_in_cents => 70)
      @transaction.save.should be_false
    end
  end
end
