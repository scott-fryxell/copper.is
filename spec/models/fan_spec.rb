require 'spec_helper'

describe Fan do
  it 'is valid empty' do
    Fan.create.should be_valid
  end
  
  describe '#current_order' do
    it 'creates an Order when there is no current order' do
      proc do
        Fan.create.current_order 
      end.should change(Order,:count).by(1)
    end
    
    it 'the returns an Order is :current state' do
      Fan.create.current_order.current?.should be_true
    end
    
    it 'finds and returns the current Order is it exists' do
      user = Fan.create
      order = user.current_order
      proc do
        user.current_order.should eq(order) 
      end.should change(Order,:count).by(0)
    end
  end
end
