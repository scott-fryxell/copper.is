require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# TODO - the BogusGateway wants a weird credit card number of '1' which sucks as it makes other tests fail.
# Right now test environment uses test Braintree Gateway, but this is dumb and slows down test execution.
# Find correct solution, probably to mod ActiveMerchant.
describe OrdersController do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions
  setup :activate_authlogic

  def user_session
    UserSession.create(users(:active))
  end

  before(:each) do
    @user = user_session
    @account = accounts(:simple)
    @address = addresses(:missoula)
  end

  def valid_post(place_order)
    post :create, { :order => {
                      :amount_in_cents => 1666
                    },
                    :account => {
                      :billing_name => @account.billing_name,
                      :number => @account.number,
                      :card_type_id => @account.card_type_id,
                      :verification_code => @account.verification_code,
                      :expires_on => @account.expires_on
                    },
                    :billing_address => {
                      :line_1 => @address.line_1,
                      :city => @address.city,
                      :state => @address.state,
                      :postal_code => @address.postal_code,
                      :country => @address.country
                    },
                    :place_order => place_order
                  }
  end

  def invalid_order(place_order)
    # Forcing failure with an invalid amount_in_cents
    post :create, { :order => {
                      :amount_in_cents => "not an integer"
                    },
                    :account => {
                      :billing_name => @account.billing_name,
                      :number => @account.number,
                      :card_type_id => @account.card_type_id,
                      :verification_code => @account.verification_code,
                      :expires_on => @account.expires_on
                    },
                    :billing_address => {
                      :line_1 => @address.line_1,
                      :city => @address.city,
                      :state => @address.state,
                      :postal_code => @address.postal_code,
                      :country => @address.country
                    },
                    :place_order => place_order
                  }
  end

  def invalid_account(place_order)
    # Forcing failure at gateway with a bad account number
    post :create,  { :order => {
                      :amount_in_cents => 1600
                    },
                    :account => {
                      :billing_name => @account.billing_name,
                      :number => 2,
                      :card_type_id => @account.card_type_id,
                      :verification_code => @account.verification_code,
                      :expires_on => @account.expires_on
                    },
                    :billing_address => {
                      :line_1 => @address.line_1,
                      :city => @address.city,
                      :state => @address.state,
                      :postal_code => @address.postal_code,
                      :country => "vuvuzela"
                    },
                    :place_order => place_order
                  }
  end

  describe "when preparing an order" do
    describe "with valid information" do
      before(:each) do
        valid_post(nil)
      end

      it "should render the page to confirm your order" do
        response.should render_template('confirm')
      end

      it "should initialize billing_address, account, and order for the confirmation page" do
        assigns['billing_address'].should_not be_nil
        assigns['billing_address'].size.should == 5
        assigns['account'].should_not be_nil
        assigns['account'].size.should == 5
        assigns['order'].should_not be_nil
        assigns['order'].size.should == 1
      end

      it "should prefill a hidden form on the confirmation page with the billing_address, account, and order values"

    end

    describe "with invalid order details" do
      before(:each) do
        invalid_order(nil)
      end

      it "should redirect to the new order page" do
        response.should render_template('new')
      end

      it "should display the errors to the user"

    end
  end

  describe "when creating an order" do

    describe "with valid information" do
      before(:each) do
        valid_post("1")
      end

      it "should display a success message when the order saves and the purchase saves" do
        flash[:notice].should contain("successful purchase")
      end

      it "should render the order confirmed page" do
        response.should render_template('success')
      end

      it "should create an order transaction record associated with the order" do
        @order = Order.find_by_amount_in_cents(1666)
        @order.order_transactions.should_not be_nil
      end

      it "should have an order-transaction with the action 'purchase'" do
        @order = Order.find_by_amount_in_cents(1666)
        @order.order_transactions[0].action.should == 'purchase'
      end

      it "should trigger the creation of a payment for the current user's account" do
        @order = Order.find_by_amount_in_cents(1666)
        @order.transaction.should_not be_nil
      end

      it "should trigger the creation of a refill for the current tip bundle" do
        @order = Order.find_by_amount_in_cents(1666)
        @order.transaction.refill.should_not be_nil
      end

      it "should trigger the creation of a fee for the makers of Weave" do
        @order = Order.find_by_amount_in_cents(1666)
        @order.transaction.fee.should_not be_nil
      end
    end

    describe "with invalid order details" do
      before(:each) do
        invalid_order("1")
      end

      it "should display a failure messages if the order does not save" do
          flash[:notice].should contain("order failed")
      end

      it "should route to an order failure page" do
        response.should render_template('new')
      end
    end

    describe "with invalid account details" do
      before(:each) do
        invalid_account("1")
      end

      it "should display a failure message if the order saves but the purchase does not go through" do
        flash[:notice].should contain("order failed")
      end

      it "should display the errors from the gateway"

      it "should route to an order failure page" do
        response.should render_template('new')
      end
    end
  end
end