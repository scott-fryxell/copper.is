require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  context do
    before(:each) do
      @tip = Tip.new(:amount_in_cents => 25)
      @tip.tip_order = FactoryGirl.create(:tip_order)
      @tip.page = FactoryGirl.create(:authored_page)
      @tip.save
    end

    it "should always be associated with a tip order" do
      @tip.tip_order = nil
      @tip.save.should be_false
    end

    it "should save" do
      @tip.save.should be_true
    end

    it "should save correctly with defaults set"  do
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

  describe "state machine" do
    it "should transition from :promised to :charged on a pay: event" do
      tip = FactoryGirl.create(:tip)
      tip.promised?.should be_true
      tip.pay
      tip.charged?.should be_true
    end
    it "should transition to :chaged to :recieved on a send_check! event" do
      tip = FactoryGirl.create(:tip_charged)
      tip.charged?.should be_true
      tip.send_check
      tip.received?.should be_true
    end
      
    it "should transition to :recieved to :cashed with a cash! event" do
      tip = FactoryGirl.create(:tip_received)
      tip.received?.should be_true
      tip.cash
      tip.cashed?.should be_true
    end
      
  end

  context 'scopes' do
    before do
      @promised = Array.new(3) { FactoryGirl.create(:tip, paid_state:'promised' ) }
      @charged = Array.new(4) { FactoryGirl.create(:tip, paid_state:'charged' ) }
      @received = Array.new(5) { FactoryGirl.create(:tip, paid_state:'received' ) }
    end

    it 'has a .promised scope' do
      Tip.promised.count.should == @promised.size
    end

    it 'has a .charged scope' do
      Tip.charged.count.should == @charged.size
    end

    it 'has a .received scope' do
      Tip.received.count.should == @received.size
    end
  end
end
