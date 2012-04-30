require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  before do
    @order = FactoryGirl.build(:order_unpaid)
    @charge_token = OpenStruct.new(id:1)
  end

  it "should save correctly when all the required values are set" do
    @order.save.should be_true
  end

  it "should require an association with a fan (user)" do
    @order.user = nil
    @order.save.should be_false
  end

  it 'process! moves a current order to unpaid' do
    order = FactoryGirl.create(:order_current)
    order.current?.should be_true
    order.process!
    order.reload
    order.unpaid?.should be_true
  end
  
  it 'process! moves a unpaid order to paid with good CC info' do
    Stripe::Charge.stub(:create) { @charge_token }
    order = FactoryGirl.create(:order_unpaid)
    order.unpaid?.should be_true
    order.process!
    order.reload
    order.paid?.should be_true
  end
  
  it 'charge! moves a unpaid order to denied to bad CC info' do
    Stripe::Charge.stub(:create).and_raise(
      Stripe::CardError.new('error[:message]', 'error[:param]', 402, 
                            "foobar", "baz", Object.new))
    order = FactoryGirl.create(:order_unpaid)
    order.unpaid?.should be_true
    proc{ order.charge! }.should raise_error(Stripe::CardError)
    order.reload
    order.denied?.should be_true
  end
  
  it 'moves a denied order to paid with good CC info' do
    Stripe::Charge.stub(:create) { @charge_token }
    order = FactoryGirl.create(:order_denied)
    order.denied?.should be_true
    order.charge!
    order.reload
    order.paid?.should be_true
  end
end

