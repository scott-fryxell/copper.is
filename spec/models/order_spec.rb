require 'spec_helper'

describe Order do
  it 'must be owned by a fan' do
    Order.create.should_not be_valid
    Fan.create.orders.create.should be_valid
  end
  
  describe 'process!' do
    before do
      @order = Fan.create.current_order
      @order.tips.create!(url:'http://test.com/guy',amount_in_cents:30)
    end
    
    it 'attempts to charge a credit card when :charge! is called' do
      with_resque do
        Stripe::Charge.should_receive(:create).and_return(double(id:1))
        @order.charge!
      end
    end
  
    it 'a successful charge changes the order\'s state to paid' do
      Stripe::Charge.should_receive(:create).and_return(double(id:1))
      @order.charge!
      @order.paid?.should be_true
    end
  
    it 'a paid order only contains :charged tips' do
      with_resque do
        Stripe::Charge.should_receive(:create).and_return(double(id:1))
        @order.charge!
        @order.tips.each do |tip|
          tip.charged?.should be_true
        end
      end
    end
    
    it 'does not allow tips to be added when :paid' do
      with_resque do
        Stripe::Charge.should_receive(:create).and_return(double(id:1))
        @order.charge!
      end
      proc do
        proc { @orders.tips.create! }.should raise_error
      end.should change(Tip,:count).by(0)
    end
  end
end
