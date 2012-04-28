require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  context do
    before(:each) do
      @tip = FactoryGirl.create(:tip)
      @tip.page = FactoryGirl.create(:authored_page)
      @tip.save!

    end

    it "should always be associated with a tip order" do
      @tip.order = nil
      @tip.save.should be_false
    end

    it "should save" do
      @tip.save.should be_true
    end

    it "should save correctly with defaults set"  do
      @tip.save.should be_true
      @tip.order.should_not be_nil
    end
  end

  it 'should not allow a tip of 0 cents' do
    @tip = Tip.new(:amount_in_cents => 0)
    @tip.order = FactoryGirl.create(:order_unpaid)
    @tip.save
    @tip.valid?.should be_false
  end

  it 'should not allow a tip of -1 cents' do
    @tip = Tip.new(:amount_in_cents => -1)
    @tip.order = FactoryGirl.create(:order_unpaid)
    @tip.save.should be_false
  end

end
