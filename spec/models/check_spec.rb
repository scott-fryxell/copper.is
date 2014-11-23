describe Check, :type => :model do
  before(:each) do
    @order = build!(:check)
  end

  it "transition from :earned to :paid on a deliver: event" do
    @check = create!(:check)
    expect(@check.earned?).to be_truthy
    @check.deliver!
    expect(@check.paid?).to be_truthy
  end

  it "transition to :paid to :cashed with a reconcile! event" do
    @check = create!(:check_paid)
    expect(@check.paid?).to be_truthy
    @check.reconcile!
    expect(@check.cashed?).to be_truthy
  end
end
