require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoyaltyBundle do
  fixtures :users, :roles_users, :addresses, :accounts, :tip_bundles, :refills, :tips

  before(:each) do
    @bundle = RoyaltyBundle.new
    @bundle.cycle_started_year    = 2011
    @bundle.cycle_started_quarter = 1
  end

  it "should save if all attributes are correctly set" do
    @bundle.should be_valid
    @bundle.save.should be_true
  end

  describe "when assigning tips to bundles" do
    before(:each) do
      @royalty1 = TipRoyalty.new
      @royalty1.royalty_bundle  = @bundle
      @royalty1.tip             = tips(:first)
      @royalty1.amount_in_cents = tips(:first).amount_in_cents
      @bundle.tip_royalties << @royalty1

      @royalty2 = TipRoyalty.new
      @royalty2.royalty_bundle  = @bundle
      @royalty2.tip             = tips(:second)
      @royalty2.amount_in_cents = tips(:second).amount_in_cents
      @bundle.tip_royalties << @royalty2
      @bundle.save
    end

    it "should have one or more tips assigned to it" do
      @bundle.should be_valid
      @bundle.tip_royalties.size.should == 2
      @bundle.tip_royalties.should include(@royalty1, @royalty2)
    end

    it "should be able to tally the total value of the associated tips" do
      @bundle.total_amount_in_cents.should == 7_50
    end
  end

  describe "when dealing with the cycle started year" do
    it "should require the year to be set" do
      @bundle.cycle_started_year = nil
      @bundle.should_not be_valid
      @bundle.save.should be_false
    end

    it "should have a numerical value" do
      @bundle.cycle_started_year = 'ham'
      @bundle.should_not be_valid
    end

    it "should be greater than 2008" do
      @bundle.cycle_started_year = 1999
      @bundle.should_not be_valid
    end

    it "should have an integer value" do
      @bundle.cycle_started_year = 2010.5
      @bundle.should_not be_valid
    end
  end

  describe "when dealing with the cycle started quarter" do
    it "should require the quarter to be set" do
      @bundle.cycle_started_quarter = nil
      @bundle.should_not be_valid
      @bundle.save.should be_false
    end

    it "should have a numerical value" do
      @bundle.cycle_started_quarter = 'wallet'
      @bundle.should_not be_valid
    end

    it "should have an integer value" do
      @bundle.cycle_started_quarter = 3.14159265
      @bundle.should_not be_valid
    end

    it "should be in the range 1 to 4" do
      @bundle.cycle_started_quarter = 0
      @bundle.should_not be_valid

      @bundle.cycle_started_quarter = 5
      @bundle.should_not be_valid

      @bundle.cycle_started_quarter = 4
      @bundle.should be_valid
    end
  end
end
