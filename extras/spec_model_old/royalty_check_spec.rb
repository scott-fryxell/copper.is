require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoyaltyOrder do
  before(:each) do
    @order = RoyaltyOrder.new
    @order.cycle_started_year    = 2011
    @order.cycle_started_quarter = 1
  end

  it "should save if all attributes are correctly set" do
    @order.should be_valid
    @order.save.should be_true
  end

  describe "when assigning tips to orders" do
    before(:each) do
      @royalty1 = Royalty.new
      @royalty1.royalty_order  = @order
      @royalty1.tip             = tips(:first)
      @royalty1.amount_in_cents = tips(:first).amount_in_cents
      @order.royalties << @royalty1

      @royalty2 = Royalty.new
      @royalty2.royalty_order  = @order
      @royalty2.tip             = tips(:second)
      @royalty2.amount_in_cents = tips(:second).amount_in_cents
      @order.royalties << @royalty2
      @order.save
    end

    it "should have one or more tips assigned to it" do
      @order.should be_valid
      @order.royalties.size.should == 2
      @order.royalties.should include(@royalty1, @royalty2)
    end

    it "should be able to tally the total value of the associated tips" do
      @order.total_amount_in_cents.should == 50
    end
  end

  describe "when dealing with the cycle started year" do
    it "should require the year to be set" do
      @order.cycle_started_year = nil
      @order.should_not be_valid
      @order.save.should be_false
    end

    it "should have a numerical value" do
      @order.cycle_started_year = 'ham'
      @order.should_not be_valid
    end

    it "should be greater than 2008" do
      @order.cycle_started_year = 1999
      @order.should_not be_valid
    end

    it "should have an integer value" do
      @order.cycle_started_year = 2010.5
      @order.should_not be_valid
    end
  end

  describe "when dealing with the cycle started quarter" do
    it "should require the quarter to be set" do
      @order.cycle_started_quarter = nil
      @order.should_not be_valid
      @order.save.should be_false
    end

    it "should have a numerical value" do
      @order.cycle_started_quarter = 'wallet'
      @order.should_not be_valid
    end

    it "should have an integer value" do
      @order.cycle_started_quarter = 3.14159265
      @order.should_not be_valid
    end

    it "should be in the range 1 to 4" do
      @order.cycle_started_quarter = 0
      @order.should_not be_valid

      @order.cycle_started_quarter = 5
      @order.should_not be_valid

      @order.cycle_started_quarter = 4
      @order.should be_valid
    end
  end
end
