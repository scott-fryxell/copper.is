require 'spec_helper'

describe Order do
  it 'must be owned my a user' do
    Order.create.should_not be_valid
    Fan.create.orders.create.should be_valid
  end
  
  it 'attempts to charge a credit card when :process! is called'
end
