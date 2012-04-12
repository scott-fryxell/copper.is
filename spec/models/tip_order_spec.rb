require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipOrder do
  describe "when creating a new tip order" do
    before(:each) do
      @order = FactoryGirl.build(:tip_order)
    end
  
    it "should save correctly when all the required values are set" do
      @order.save.should be_true
    end
  
    it "should require an association with a fan (user)" do
      @order.user = nil
      @order.save.should be_false
    end
  end
  
  it "should have a unique tip order for each user" do
    TipOrder.create(:user => FactoryGirl.create(:user))
    TipOrder.new(:user => FactoryGirl.create(:user)).save.should be_true
  end
  
  describe "when working with users" do
    before do
      @order = FactoryGirl.create(:tip_order)
    end
  
    it "should determine the correct active tip order" do
      @order.id.should == @order.user.tip_orders.current.first.id
    end
  
    describe "when rotating tip orders" do
      it "should close the old order without error" do
        lambda { users(:a_fan).rotate_tip_order! }.should_not raise_error
      end
  
      it "should produce a new tip order different from the old one" do
        users(:a_fan).rotate_tip_order!
        users(:a_fan).active_tip_order.should_not == @order
      end
  
      it "should produce a new empty tip order" do
        users(:a_fan).rotate_tip_order!
        users(:a_fan).active_tip_order.tips.size.should == 0
      end
    end
  end
  
  describe "when calculating where the money is for the order" do
    before(:each) do
      @order = TipOrder.new
      @order.fan = users(:a_developer)
      @order.save
  
      locator1 = Locator.parse('http://example.com')
      locator1.page = Page.new(:description => 'example page')
      tip1 = Tip.new(:amount_in_cents => 25)
      tip1.locator = locator1
      @order.tips << tip1
  
      locator2 = Locator.parse('http://beefdeed.com/chunder')
      locator2.page = Page.new(:description => 'CHUNDER POW')
      tip2 = Tip.new(:amount_in_cents => 25)
      tip2.locator = locator2
      @order.tips << tip2
  
      locator3 = Locator.parse('http://beefdeed.com/horde')
      locator3.page = Page.new(:description => 'ALL HAIL THE HORDE')
      tip3 = Tip.new(:amount_in_cents => 25)
      tip3.locator = locator3
      @order.tips << tip3
  
      @order.save
    end
  
    it "should have a way to total up the number of associated tips" do
      @order.tips.size.should == 3
    end
  
    it "should be able to determine the value of all the tips" do
      total = 0
  
      total = @order.tips.sum('amount_in_cents');
  
      total.should == 75
    end
  
  end
  describe "paying for an order of tips" do
    before(:each) do
  
      stripe = Stripe::Token.create(
          :card => {
          :number => "4242424242424242",
          :exp_month => 3,
          :exp_year => 2013,
          :cvc => 314
        },
          :currency => "usd"
      )
  
      @user = users(:twitter_fan)
      @user.create_stripe_customer(stripe.id)
      @user.save
    end
  
    after(:each) do
      @user.delete_stripe_customer
    end
  
    it "should charge the fan for his tips" do
      @order = @user.active_tip_order
      @user.rotate_tip_order!
      users(:twitter_fan).active_tip_order.should_not == @order
      @order.tips.size.should == 8
      @order.tips.sum(:amount_in_cents).should == 800
      @order.charge.should_not be_nil
      @order.charge_token.should_not be_nil
    end
  
  end
  
  context 'scopes' do
    before do
      @current_order = FactoryGirl.create(:tip_order, state:'current')
      @paid_orders = Array.new(2) { FactoryGirl.create(:tip_order, state:'paid') }
      @declined_orders = Array.new(2) { FactoryGirl.create(:tip_order, state:'declined') }
    end

    it 'has a .current scope' do
      TipOrder.current.first.id.should == @current_order.id
    end

    it 'has a .paid scope' do
      TipOrder.paid.count.should == @paid_orders.size
    end

    it 'has a .declined scope' do
      TipOrder.declined.count.should == @declined_orders.size
    end
  end
end
