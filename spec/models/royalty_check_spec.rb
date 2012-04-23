require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoyaltyCheck do
  before(:each) do
    @order = FactoryGirl.build(:royalty_check)
  end

  it "should save if all attributes are correctly set" do
    @order.should be_valid
    @order.save.should be_true
  end


  describe "state machine" do
    it "should transition from :earned to :paid on a deliver: event" do
      @royalty_check = FactoryGirl.create(:royalty_check)
      @royalty_check.earned?.should be_true
      @royalty_check.deliver
      @royalty_check.paid?.should be_true
    end
    it "should transition to :paid to :cashed with a reconcile! event" do
      @royalty_check = FactoryGirl.create(:royalty_check_paid)
      @royalty_check.paid?.should be_true
      @royalty_check.reconcile
      @royalty_check.cashed?.should be_true
    end
  end


  context 'scopes' do
    before do
      @earned_checks = Array.new(1) { FactoryGirl.create(:royalty_check, check_state:'earned') }
      @paid_checks = Array.new(1) { FactoryGirl.create(:royalty_check, check_state:'paid') }
      @cashed_checks = Array.new(1) { FactoryGirl.create(:royalty_check, check_state:'cashed') }
    end

    it 'has a .earned scope' do
      RoyaltyCheck.earned.count.should == @earned_checks.size
    end

    it 'has a .paid scope' do
      RoyaltyCheck.paid.count.should == @paid_checks.size
    end

    it 'has a .cashed scope' do
      RoyaltyCheck.cashed.count.should == @cashed_checks.size
    end
  end
  
end
