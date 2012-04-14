require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Royalty do
  before(:each) do
    @order = RoyaltyOrder.new
    @order.cycle_started_year    = 2011
    @order.cycle_started_quarter = 1

    @royalty = Royalty.new
    @royalty.amount_in_cents = 25
    @royalty.royalty_order = @order
    @royalty.tip = tips(:first)
  end

  it "should save if all values are correctly set" do
    @royalty.should be_valid
    @royalty.save.should be_true
  end

  it "should be assigned to a royalty order" do
    @royalty.royalty_order = nil
    @royalty.should_not be_valid
  end

  it "should be assigned to a tip" do
    @royalty.tip = nil
    @royalty.should_not be_valid
  end

  it "should have a cash value" do
    @royalty.amount_in_cents = nil
    @royalty.should_not be_valid
  end

  it "should have a cash value in whole cents" do
    @royalty.amount_in_cents = 38.5
    @royalty.should_not be_valid
  end

  it "should have a cash value greater than 0" do
    @royalty.amount_in_cents = -5_00
    @royalty.should_not be_valid
  end

  it "should match the tip value back to the originating tip" do
    @royalty.should be_valid_tip_value
  end
end
