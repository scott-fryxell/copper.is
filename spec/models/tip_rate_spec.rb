require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipRate do
  fixtures :tip_rates

  before(:each) do
    @tr = TipRate.new
    @tr.amount_in_cents = 1
  end

  it "should save if all values are acceptable" do
    @tr.save.should be_true
  end

  it "should have an amount_in_cents" do
    @tr.amount_in_cents = nil
    @tr.save.should be_false
  end

  it "should not allow more than one entry for the same amount" do
    @tr.save

    @tr_dup = TipRate.new
    @tr_dup.amount_in_cents = 1
    @tr_dup.save.should be_false
  end

  it "should not allow non-numeric, non-whole, non-postive values to be set in the amount_in_cents column" do
    @tr.amount_in_cents = 'foo'
    @tr.save.should be_false

    @tr.amount_in_cents = -10
    @tr.save.should be_false

    @tr.amount_in_cents = 10_70.75
    @tr.save.should be_false
  end
end