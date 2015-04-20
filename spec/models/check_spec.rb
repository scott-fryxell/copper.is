require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Check do
  before(:each) do
    mock_user
    @order = FactoryGirl.build(:check)
  end

  it "transition from :earned to :paid on a deliver: event" do
    @check = FactoryGirl.create(:check)
    @check.earned?.should be_true
    @check.deliver!
    @check.paid?.should be_true
  end

  it "transition to :paid to :cashed with a reconcile! event" do
    @check = FactoryGirl.create(:check_paid)
    @check.paid?.should be_true
    @check.reconcile!
    @check.cashed?.should be_true
  end
end