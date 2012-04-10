require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipOrder do
  describe "when creating a new tip order" do
    before(:each) do
      @order = TipOrder.new
      @order.fan = users(:a_developer)
    end

    it "should save correctly when all the required values are set" do
      @order.save.should be_true
    end

    it "should require an association with a fan (user)" do
      @order.fan = nil
      @order.save.should be_false
    end

    it "should default to active upon creation" do
      @order.is_active.should be_true
    end
  end

  it "should only be one active tip order per user" do
    TipOrder.create(:fan => users(:a_fan))
    TipOrder.new(:fan => users(:a_fan)).save.should be_false
  end

  it "should have a unique tip order for each user" do
    TipOrder.create(:fan => users(:an_administrator))
    TipOrder.new(:fan => users(:a_developer)).save.should be_true
  end

  it "should find all the associated tips for the order" do
    tip_orders(:active_order).tips.should include(tips(:first))
    tip_orders(:active_order).tips.should include(tips(:second))
    tip_orders(:active_order).tips.should include(tips(:third))
    tip_orders(:active_order).tips.should include(tips(:fourth))
    tip_orders(:active_order).tips.should include(tips(:fifth))
    tip_orders(:active_order).tips.should include(tips(:sixth))
    tip_orders(:active_order).tips.should include(tips(:seventh))
    tip_orders(:active_order).tips.should include(tips(:eigth))
  end

  describe "when working with users" do
    before(:each) do
      @order = tip_orders(:active_order)
    end

    it "should determine the correct active tip order" do
      @order.should == users(:a_fan).active_tip_order
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
end
