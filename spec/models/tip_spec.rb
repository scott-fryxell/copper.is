require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  before :each do
    me_setup
  end
  context do
    it "should always be associated with a tip order" do
      @my_tip.order = nil
      @my_tip.save.should be_false
    end

    it "should save" do
      @my_tip.save.should be_true
    end

    it "should save correctly with defaults set"  do
      @my_tip.save.should be_true
      @my_tip.order.should_not be_nil
    end

    after do
      @my_tip.order = @me.current_order
    end
  end

  it 'should not allow a tip of 0 cents' do
    @my_tip = Tip.new(:amount_in_cents => 0)
    @my_tip.order = create!(:order_unpaid)
    @my_tip.save
    @my_tip.valid?.should be_false
  end

  it 'should not allow a tip of -1 cents' do
    @my_tip = Tip.new(:amount_in_cents => -1)
    @my_tip.order = create!(:order_unpaid)
    @my_tip.save.should be_false
  end
end
