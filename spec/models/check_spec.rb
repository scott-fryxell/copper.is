require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Check do
  before(:each) do
    @order = FactoryGirl.build(:check)
  end

  it "should save if all attributes are correctly set" do
    @order.should be_valid
    @order.save.should be_true
  end


  describe "state machine" do
    it "should transition from :earned to :paid on a deliver: event" do
      @check = FactoryGirl.create(:check)
      @check.earned?.should be_true
      @check.deliver
      @check.paid?.should be_true
    end
    it "should transition to :paid to :cashed with a reconcile! event" do
      @check = FactoryGirl.create(:check_paid)
      @check.paid?.should be_true
      @check.reconcile
      @check.cashed?.should be_true
    end
  end


  context 'scopes' do
    before do
      @earned_checks = Array.new(1) { FactoryGirl.create(:check, check_state:'earned') }
      @paid_checks = Array.new(1) { FactoryGirl.create(:check, check_state:'paid') }
      @cashed_checks = Array.new(1) { FactoryGirl.create(:check, check_state:'cashed') }
    end

    it 'has a .earned scope' do
      Check.earned.count.should == @earned_checks.size
    end

    it 'has a .paid scope' do
      Check.paid.count.should == @paid_checks.size
    end

    it 'has a .cashed scope' do
      Check.cashed.count.should == @cashed_checks.size
    end
  end
  
end
