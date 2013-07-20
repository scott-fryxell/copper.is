require 'spec_helper'

describe OrdersController do
  before :each do
    mock_page_and_user
    mock_order
    @me = create!(:user)
    @me.current_order.rotate!
    @me.orders.unpaid.first.charge!
    @my_paid_order = @me.orders.paid.first
    @my_denied_order = FactoryGirl.create(:order_denied,user:@me)
  end

  describe 'as Guest' do
    before :all do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do
      describe '/orders' do
        it '302' do
          get :index
          response.status.should == 401
        end
      end
    end

    describe 'show' do
      describe '/orders/:id' do
        it 'responds with not athorized' do
          get :show, id:@my_paid_order.id
          response.status.should == 401
        end
      end
    end
  end

  describe 'as fan', :broken do
    before :each do
      admin_setup
      @her = create!(:user)
      @her.current_order.rotate!
      @her.orders.unpaid.first.charge!
      @her_paid_order = @her.orders.paid.first
      @her_denied_order = FactoryGirl.create(:order_denied,user:@her)
    end

    describe 'index' do
      describe '/orders' do
        it 'displays all the orders' do
          get_with @admin, :index
          assigns(:orders).include?(@her_paid_order).should be_true
          response.status.should == 200
        end
      end

      describe '/orders?state=paid' do
        it 'with ?order_state=paid, renders all paid orders for current user' do
          get_with @admin, :index, state:'paid'
          assigns(:orders).include?(@my_paid_order).should be_true
          assigns(:orders).include?(@her_paid_order).should be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end

      describe '/orders?state=denied' do
        it 'with ?order_state=denied, renders all denied orders for current user' do
          get_with @me, :index, state:'denied'
          assigns(:orders).include?(@my_paid_order).should_not be_true
          assigns(:orders).include?(@her_paid_order).should_not be_true
          assigns(:orders).include?(@my_denied_order).should be_true
          assigns(:orders).include?(@her_denied_order).should be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end
    end

    describe 'show' do

      describe '/orders/:id' do
        it 'assigns given order when owned by current user' do
          get_with @admin, :show, id:@my_paid_order.id
          assigns(:order).id.should == @my_paid_order.id
        end

        it 'assigns given denied order when owned by current user' do
          get_with @admin, :show, id:@my_denied_order.id
          assigns(:order).id.should == @my_denied_order.id
        end

        it '401 if order is not owned by current user' do
          get_with @admin, :show, id:@her_denied_order.id
          response.status.should == 401
        end
      end
    end
  end

  describe 'as Admin' do
    before :each do
      admin_setup
      @her = create!(:user)
      @her.current_order.rotate!
      @her.orders.unpaid.first.charge!
      @her_paid_order = @her.orders.paid.first
      @her_denied_order = FactoryGirl.create(:order_denied,user:@her)
    end

    describe 'index' do
      describe '/orders' do
        it 'displays all the orders' do
          get_with @admin, :index
          assigns(:orders).include?(@her_paid_order).should be_true
          response.status.should == 200
        end
      end

      describe '/orders?state=paid' do
        it 'with ?order_state=paid, renders all paid orders for current user' do
          get_with @admin, :index, state:'paid'
          assigns(:orders).include?(@my_paid_order).should be_true
          assigns(:orders).include?(@her_paid_order).should be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end

      describe '/orders?state=denied' do
        it 'with ?order_state=denied, renders all denied orders for current user' do
          get_with @me, :index, state:'denied'
          assigns(:orders).include?(@my_paid_order).should_not be_true
          assigns(:orders).include?(@her_paid_order).should_not be_true
          assigns(:orders).include?(@my_denied_order).should be_true
          assigns(:orders).include?(@her_denied_order).should be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end
    end

    describe 'show' do

      describe '/orders/:id' do
        it 'assigns given order when owned by current user' do
          get_with @admin, :show, id:@my_paid_order.id
          assigns(:order).id.should == @my_paid_order.id
        end

        it 'assigns given denied order when owned by current user' do
          get_with @admin, :show, id:@my_denied_order.id
          assigns(:order).id.should == @my_denied_order.id
        end

        it '200 even if not owned by current user' do
          get_with @admin, :show, id:@her_denied_order.id
          response.status.should == 200
        end
      end
    end
  end

end

