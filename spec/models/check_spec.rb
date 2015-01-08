describe Check, :type => :model do

  subject {build!(:check)}

  it "transition from :earned to :paid on a deliver: event" do
    expect(subject.earned?).to be_truthy
    subject.deliver!
    expect(subject.deposited?).to be_truthy
  end

  it "transition to :paid to :cashed with a reconcile! event" do
    check = build!(:check_deposited)
    expect(check.deposited?).to be_truthy
    check.reconcile!
    expect(check.cashed?).to be_truthy
  end
end
