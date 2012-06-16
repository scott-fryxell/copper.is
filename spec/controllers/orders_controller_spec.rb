require 'spec_helper'

describe OrdersController  do
  before :each do
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
          response.status.should == 401
        end
      end
    end
    
    describe 'new' do
      describe '/orders/new' do
        it '302' do
          get :new
          response.status.should == 401
        end
      end
    end
    
    describe 'create' do
      describe 'POST /orders' do
        it '302' do
          post :create
          response.status.should == 401
        end
      end
    end
    
    describe 'show' do
      describe '/orders/:id' do
        it '302' do
          get :show, id:@my_paid_order.id
          response.status.should == 401
        end
      end
    end
    
    describe 'edit' do
      describe '/orders/:id/edit' do
        it '302' do
          get :edit, id:@my_paid_order.id
          response.status.should == 401
        end
      end
    end
    
    describe 'update' do
      describe 'PUT /orders/:id' do
        it '302' do
          put :update, id:@my_paid_order.id
          response.status.should == 401
        end
      end
    end
    
    describe 'destroy' do
      describe 'DELETE /orders/:id' do
        it '302' do
          delete :destroy, id:@my_paid_order.id
          response.status.should == 401
        end
      end
    end
  end

  describe 'as Fan' do
    before :each do
      user = @me
      controller.instance_eval do
        cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
        @current_user = user
      end
    end
      
    before :each do
      @her.current_order.rotate!
      @her.orders.unpaid.first.charge!
      @her_paid_order = @her.orders.paid.first
      @her_denied_order = FactoryGirl.create(:order_denied,user:@her)
    end

    describe 'index' do
      it 'responds to .json' do
        get :index, format: :json 
        response.should be_success
        response.body.should include(@my_paid_order.to_json)
      end
      
      describe '/orders' do
        it 'assigns orders for current user: current, unpaid, paid and denied' do
          get :index
          assigns(:orders).include?(@my_paid_order).should be_true
          assigns(:orders).include?(@her_paid_order).should_not be_true
          # assigns(:orders).include?(@me.current_order).should be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end

      describe '/orders?s=paid' do
        it 'with ?state=paid, renders all paid orders for current user' do
          get :index, s:'paid'
          assigns(:orders).include?(@my_paid_order).should be_true
          assigns(:orders).include?(@her_paid_order).should_not be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end

      describe '/orders?s=denied' do
        it 'with ?state=denied, renders all denied orders for current user' do
          get :index, s:'denied'
          assigns(:orders).include?(@my_paid_order).should_not be_true
          assigns(:orders).include?(@her_paid_order).should_not be_true
          assigns(:orders).include?(@my_denied_order).should be_true
          assigns(:orders).include?(@her_denied_order).should_not be_true
          assigns(:orders).include?(@me.current_order).should_not be_true
          assigns(:orders).include?(@her.current_order).should_not be_true
          response.status.should == 200
        end
      end
    end

    describe 'new' do
      describe '/orders/new' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /orders' do
        it '403' do
          post :create
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/orders/current' do
        it 'responds to .json' do pending
          get :show, id:'current', format: :json 
          response.should be_success
          response.body.should include(@my_paid_order.to_json)
        end
        
        it 'assigns the current open order of current user' do pending
          get :show, id:'current'
          assigns(:order).id.should == @me.current_order.id
          response.status.should == 200
        end
      end

      describe '/orders/:id' do
        it 'assigns given order when owned by current user' do
          get :show, id:@my_paid_order.id
          assigns(:order).id.should == @my_paid_order.id
        end

        it 'assigns given denied order when owned by current user' do
          get :show, id:@my_denied_order.id
          assigns(:order).id.should == @my_denied_order.id
        end

        it '401 if order is not owned by current user' do
          get :show, id:@her_denied_order.id
          response.status.should == 401
        end
      end
    end

    describe 'edit' do
      describe '/orders/current/edit' do
        it 'assigns the current order of the current user' do
          get :edit, id:@my_paid_order.id
          assigns(:order).id.should == @my_paid_order.id
        end
      end


      it 'assigns given denied order when owned by current user' do
        get :edit, id:@my_denied_order.id
        assigns(:order).id.should == @my_denied_order.id
      end

      it '401 if order is not owned by current user' do pending
        get :edit, id:@her_denied_order.id
        assigns(:order).should be_nil
        response.status.should == 401
      end
    end

    describe 'update' do
      describe 'PUT /orders/current' do
        it 'prepares! the current order for the current user'
        it "doesn't allow any column updates to the order"
      end

      describe 'PUT /orders/:id' do
        before do
          @my_new_tip = @me.tip(url:@page1.url)
          @order_id = @me.current_order.id
          @my_new_tip.promised?.should be_true
        end
        
        it 'pays current order for the current user' do
          put :update, id:@me.current_order.id, terms:true, strip_token:123
          @my_new_tip.reload
          @my_new_tip.charged?.should be_true
          Order.find(@order_id).paid?.should be_true
        end
        
        it 'pays a denied order for the current user' do
          @my_denied_order.denied?.should be_true
          put :update, id:@my_denied_order.id, terms:true, strip_token:123
          @my_denied_order.reload
          @my_denied_order.paid?.should be_true
        end
        
        it "doesn't allow any column updates to the order" do
          put :update, id:@me.current_order.id, terms:true, strip_token:123,
                       state:'denied' 
          @my_new_tip.reload
          @my_new_tip.charged?.should be_true
          Order.find(@order_id).paid?.should be_true
        end
        
        it '401 if not owned by current user' do
              put :update, id:@her_denied_order.id, terms:true,
                           strip_token:123, state:'denied'
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /orders/current' do
        it 'destroys all contained tips, destroys current order and creates a new order'
      end

      describe 'DELETE /orders/:id' do
        it 'if :id is the current order it destroys all contained tips, destroys current order and creates a new order'
        it '401 if order is not current and owned by current user'
        it '401 it order is not current and not owned by current user'
      end
    end
  end
end

