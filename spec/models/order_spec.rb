require 'spec_helper'

describe Order do
  it 'must be owned my a user' do
    Order.create.should_not be_valid
    Fan.create.orders.create.should be_valid
  end
  
  it 'attempts to charge a credit card when :process! is called' do
    Strip::Charge.should_receive(:create)
    order = Fan.create.current_order
    order.tips.create!(url:'http://test.com/guy',amount_in_cents:30)
    order.process!
  end
  
  it 'a successful charge changes the order\'s state to paid' do
    Strip::Charge.should_receive(:create).and_return(double(id:1))
    order = Fan.create.current_order
    order.tips.create!(url:'http://test.com/guy',amount_in_cents:30)
    order.process!
    order.paid?.should be_true
  end
end
