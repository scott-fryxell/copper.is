require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip, :type => :model do
  before :each do
    me_setup
  end
  context do
    it "should always be associated with a tip order" do
      @my_tip.order = nil
      expect(@my_tip.save).to be_falsey
    end

    it "should save" do
      expect(@my_tip.save).to be_truthy
    end

    it "should save correctly with defaults set"  do
      expect(@my_tip.save).to be_truthy
      expect(@my_tip.order).not_to be_nil
    end

    after do
      @my_tip.order = @me.current_order
    end
  end

  it 'should not allow a tip of 0 cents' do
    @my_tip = Tip.new(:amount_in_cents => 0)
    @my_tip.order = create!(:order_unpaid)
    @my_tip.save
    expect(@my_tip.valid?).to be_falsey
  end

  it 'should not allow a tip of -1 cents' do
    @my_tip = Tip.new(:amount_in_cents => -1)
    @my_tip.order = create!(:order_unpaid)
    expect(@my_tip.save).to be_falsey
  end
end
