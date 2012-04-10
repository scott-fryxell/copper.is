require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  describe 'some tests' do
    before(:each) do
      @tip = Tip.new(:amount_in_cents => 25)
      @tip.tip_order = tip_orders(:active_order)
      @tip.locator = locators(:minimal)
      @tip.save!
    end

    it "should always be associated with a tip order" do
      @tip.tip_order = nil
      @tip.save.should be_false
    end

    it "should always be associated with a URL" do
      @tip.locator = nil
      @tip.save.should be_false
    end

    it "should save correctly with defaults set" do
      @tip.save.should be_true
      @tip.tip_order.should_not be_nil
      @tip.locator.should_not be_nil
    end
  end
  
  it 'should not allow a tip of 0 cents' do
    @tip = Tip.new(:amount_in_cents => 0)
    @tip.tip_order = tip_orders(:active_order)
    @tip.locator = locators(:minimal)
    @tip.save
    @tip.valid?.should be_false
  end
  
  it 'should not allow a tip of -1 cents' do
    @tip = Tip.new(:amount_in_cents => -1)
    @tip.tip_order = tip_orders(:active_order)
    @tip.locator = locators(:minimal)
    @tip.save.should be_false
  end
end
