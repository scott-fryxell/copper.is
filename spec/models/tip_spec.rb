require 'spec_helper'

describe Tip do
  describe 'without resque' do
    before do
      @order = Fan.create.current_order
      @tip = @order.tips.create!(amount_in_cents:10,url:'http://test.com')
    end
    
    it 'is valid with an amount, an order, and a URL' do
      @tip.should be_valid
    end
    
    it 'can access it\'s Order' do
      @tip.order.should eq(@order)
    end
    
    it 'can access it\'s Fan' do
      @tip.fan.should eq(@order.fan)
    end
    
    it 'is not initially associated with a Check' do
      @tip.check.should be_nil
    end
    
    it 'is not initially associated with an Author' do
      @tip.author.should be_nil
    end
    
    it 'is not initially associated with a Page' do
      @tip.page.should be_nil
    end
    
    it 'is not initially associated with a Site' do
      @tip.site.should be_nil
    end
    
    it 'queues the find_or_create_page! job' do
      Tip.should have_queued(@tip.id, :find_or_create_page!)
    end
    
    it 'a new tip is in promised state' do
      @tip.promised?.should be_true
    end
  end
  
  describe 'with resque' do
    before do
      with_resque do
        @order = Fan.create.current_order
        @tip = @order.tips.create!(amount_in_cents:10,url:'http://test.com')
        @tip.reload
        @order.reload
      end
    end
    
    it 'is associated with a Page' do
      @tip.page.should_not be_nil
    end
    
    it 'is associated with a Site' do
      @tip.site.should_not be_nil
    end
    
    it 'is associated with a Author' do
      @tip.author.should_not be_nil
    end
  end
end
