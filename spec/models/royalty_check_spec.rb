require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoyaltyCheck do
  before(:each) do
    @order = FactoryGirl.build(:royalty_check)
  end

  it "should save if all attributes are correctly set" do
    @order.should be_valid
    @order.save.should be_true
  end

  context 'scopes' do
    before do
      @earned_checks = Array.new(3) { FactoryGirl.create(:royalty_check, state:'earned') }
      @paid_checks = Array.new(2) { FactoryGirl.create(:royalty_check, state:'paid') }
      @cashed_checks = Array.new(2) { FactoryGirl.create(:royalty_check, state:'cashed') }
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
