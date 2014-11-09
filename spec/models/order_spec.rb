require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order, :type => :model do
  before do
    mock_user
    mock_order
    @order = build!(:order_unpaid)

  end

  it "should save correctly when all the required values are set" do
    expect(@order.save).to be_truthy
  end

  it "should require an association with a fan (user)" do
    @order.user = nil
    expect(@order.save).to be_falsey
  end

  it 'process! moves a current order to unpaid' do
    order = create!(:order_current)
    expect(order.current?).to be_truthy
    order.process!
    order.reload
    expect(order.unpaid?).to be_truthy
  end

  it 'charge! moves a unpaid order to paid with good CC info' do
    order = create!(:order_unpaid)
    expect(order.unpaid?).to be_truthy
    order.charge!
    order.reload
    expect(order.paid?).to be_truthy
  end

  it 'charge! moves a unpaid order to denied to bad CC info' do
    allow(Stripe::Charge).to receive(:create).and_raise(
      Stripe::CardError.new('error[:message]', 'error[:param]', 402,
                            "foobar", "baz", Object.new))
    order = create!(:order_unpaid)
    expect(order.unpaid?).to be_truthy
    expect{ order.charge! }.to raise_error(Stripe::CardError)
    order.reload
    expect(order.denied?).to be_truthy
  end

  it 'moves a denied order to paid with good CC info' do
    # Stripe::Charge.stub(:create) { @charge_token }
    order = create!(:order_denied)
    expect(order.denied?).to be_truthy
    order.charge!
    order.reload
    expect(order.paid?).to be_truthy
  end
end
