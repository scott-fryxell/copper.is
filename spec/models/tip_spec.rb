require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  context do
    before(:each) do
      @tip = Tip.new(:amount_in_cents => 25)
      @tip.tip_order = FactoryGirl.create(:tip_order)
      @tip.save
    end

    it "should always be associated with a tip order", :focus do
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
    end
  end
  
  it 'should not allow a tip of 0 cents' do
    @tip = Tip.new(:amount_in_cents => 0)
    @tip.tip_order = FactoryGirl.create(:tip_order)
    @tip.save
    @tip.valid?.should be_false
  end
  
  it 'should not allow a tip of -1 cents' do
    @tip = Tip.new(:amount_in_cents => -1)
    @tip.tip_order = FactoryGirl.create(:tip_order)
    @tip.save.should be_false
  end
end
