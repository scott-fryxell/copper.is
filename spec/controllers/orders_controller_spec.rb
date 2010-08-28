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

  def valid_post(method, commit, account, address)
    post method, { :order => {
                      :amount_in_cents => 1666
                    },
                    :account => {
                      :billing_name => account.billing_name,
                      :number => account.number,
                      :card_type_id => account.card_type_id,
                      :verification_code => account.verification_code,
                      :expires_on => account.expires_on

                    },
                    :billing_address => {
                      :line_1 => address.line_1,
                      :city => address.city,
                      :state => address.state,
                      :postal_code => address.postal_code,
                      :country => address.country
                    },
                    :commit => commit
                  }
  end

  def invalid_order(method, commit, account, address)
    # Forcing failure with an invalid amount_in_cents
    post method, { :order => {
                      :amount_in_cents => "not an integer"
                    },
                    :account => {
                      :billing_name => account.billing_name,
                      :number => account.number,
                      :card_type_id => account.card_type_id,
                      :verification_code => account.verification_code,
                      :expires_on => account.expires_on
                    },
                    :billing_address => {
                      :line_1 => address.line_1,
                      :city => address.city,
                      :state => address.state,
                      :postal_code => address.postal_code,
                      :country => address.country
                    },
                    :commit => commit
                  }
  end

  def invalid_account(method, commit, account, address)
    # Forcing failure at gateway with a bad account number
    post method,  { :order => {
                      :amount_in_cents => 1600
                    },
                    :account => {
                      :billing_name => account.billing_name,
                      :number => 2,
                      :card_type_id => account.card_type_id,
                      :verification_code => account.verification_code,
                      :expires_on => account.expires_on
                    },
                    :billing_address => {
                      :line_1 => address.line_1,
                      :city => address.city,
                      :state => address.state,
                      :postal_code => address.postal_code,
                      :country => "vuvuzela"
                    },
                    :commit => commit
                  }
  end

  describe "when preparing an order" do
    describe "with valid information" do
      before(:each) do
        valid_post("prepare", "Continue", @account, @address)
      end

      it "should render the page to confirm your order" do
        response.should render_template('prepare')
      end

      it "should initialize billing_address, account, and order for the prepare page" do
        assigns['billing_address'].should_not be_nil
        assigns['account'].should_not be_nil
        assigns['order'].should_not be_nil
      end

    end

    describe "with invalid order details" do
      before(:each) do
        invalid_order("prepare", "Continue", @account, @address)
      end

      it "should redirect to the new order page" do
        response.should render_template('new')
      end

      it "should display the errors to the user" do
        flash[:error].should_not be_nil
      end

    end
  end

  describe "when creating an order" do

    describe "with valid information" do
      before(:each) do
        valid_post("create", "Make Payment", @account, @address)
      end

      it "should display a success message when the order saves and the purchase saves" do
        flash[:notice].should contain("successful purchase")
      end

      it "should render the order confirmed page" do
        response.should render_template('show')
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
        invalid_order("create", "Make Payment", @account, @address)
      end

      it "should display a failure messages if the order does not save" do
        flash[:error].should_not be_nil
      end

      it "should route to an order failure page" do
        response.should render_template('new')
      end
    end

    describe "with invalid account details" do
      before(:each) do
        invalid_account("create", "Make Payment", @account, @address)
      end

      it "should display a failure message if the order saves but the purchase does not go through" do
        flash[:error].should_not be_nil
      end

      it "should display the errors from the gateway" do
        flash[:error].should contain("Type is not the correct card type")
      end

      it "should route to an order failure page" do
        response.should render_template('new')
      end
    end
  end
end