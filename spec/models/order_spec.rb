require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  describe "when creating a new tip order" do
    before do
      @order = FactoryGirl.build(:order_unpaid)
    end

    it "should save correctly when all the required values are set" do
      @order.save.should be_true
    end

    it "should require an association with a fan (user)" do
      @order.user = nil
      @order.save.should be_false
    end
  end

  it "should have a unique current tip order for each user" # do
  #   order = Order.new
  #   order.user = FactoryGirl.create(:user)
  #   Order.new(:user => order.user).save.should be_false
  # end

  describe "when calculating where the money is for the order" do
    before do
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:order_unpaid, user:@user)
      @user.tip(:url => 'http://example.com', :title => 'example page', :amount_in_cents => 25)
      @user.tip(:url => 'http://beefdeed.com/chunder', :title => 'CHUNDER POW', :amount_in_cents => 25)
      @user.tip(:url => 'http://beefdeed.com/horde', :title => 'ALL HAIL THE HORDE', :amount_in_cents => 25)
    end

    it "should have a way to total up the number of associated tips" do
      @user.current_tips.size.should == 3
    end

    it "should be able to determine the value of all the tips" do
      total = 0

      total = @user.current_tips.sum('amount_in_cents');

      total.should == 75
    end

  end
  describe "paying for an order of tips" do
    before do

      stripe = Stripe::Token.create(
          :card => {
          :number => "4242424242424242",
          :exp_month => 3,
          :exp_year => 2013,
          :cvc => 314
        },
          :currency => "usd"
      )

      @user = FactoryGirl.build(:user)
      @user.create_stripe_customer(stripe.id)
      @user.save
    end

    after(:each) do
      @user.delete_stripe_customer
    end

    it "should charge the fan for his tips"  do
      @order = @user.current_order
      @order.unpaid?.should be_true
      @user.tip(:url => 'http://example.com', :title => 'example page', :amount_in_cents => 500)
      @user.tip(:url => 'http://beefdeed.com/chunder', :title => 'CHUNDER POW', :amount_in_cents => 500)
      @user.tip(:url => 'http://beefdeed.com/horde', :title => 'ALL HAIL THE HORDE', :amount_in_cents => 500)
      @user.current_order.process!
      Order.find(@order.id).paid?.should be_true
      @order.tips.size.should == 3
      @order.tips.sum(:amount_in_cents).should == 1500
    end

  end

  describe "state machine" do
    before do
      @charge_token = Object.new
      def @charge_token.id() 1 end
    end
    
    it "should transition from :ready to :paid on a process! event and valid payment info"  do
      Stripe::Charge.stub(:create) { @charge_token }
      @order = FactoryGirl.create(:order_unpaid)
      @order.state_name.should == :unpaid
      @order.process!
      @order.state_name.should == :paid
    end
    
    it "should transition from :ready to :declined on a process! event and not enough funds"#  do
    #   Stripe::Charge.stub(:create).and_raise(Stripe::CardError.new('error[:message]', 'error[:param]', 402, "foobar", "baz", Object.new))
    #   @order = FactoryGirl.create(:order_ready)
    #   @order.state_name.should == :ready
    #   @order.process
    #   @order.state_name.should == :declined
    # end
    
    it "should transition from :declined to :paid on a process! event and valid payment info" do
      Stripe::Charge.stub(:create) { @charge_token }
      @order = FactoryGirl.create(:order_declined)
      @order.state_name.should == :declined
      @order.process
      @order.state_name.should == :paid
    end
    
    it "should transition to :declined to :declined on a process! event and not enough funds"#  do
    #   Stripe::Charge.stub(:create).and_raise(Stripe::CardError.new('error[:message]', 'error[:param]', 402, "foobar", "baz", Object.new))
    #   @order = FactoryGirl.create(:order_declined)
    #   @order.state_name.should == :declined
    #   @order.process
    #   @order.state_name.should == :declined
    # end
  end

  describe 'scopes' do
    before do
      @user = FactoryGirl.create(:user)
      @current_order = @user.current_order
      @paid_orders = Array.new(2) {
         to = @user.orders.build()
         to.state = "paid"
         to.save
      }
      @declined_orders = Array.new(2) {
         to = @user.orders.build()
         to.state = "declined"
         to.save
       }
    end

    it 'has a .current scope'  do
      Order.unpaid.first.id.should == @current_order.id
    end

    it 'has a .paid scope' do
      Order.paid.count.should == @paid_orders.size
    end

    it 'has a .declined scope' do
      Order.declined.count.should == @declined_orders.size
    end
  end
end
