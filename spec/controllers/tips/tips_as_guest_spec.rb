require 'spec_helper'

describe TipsController do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do
      describe '/tips' do
        it 'responds to .json' do
          get :index, format: :json
          response.should be_success
          order_id = @her_tip2.order_id
          check_id = @her_tip2.check_id
          @her_tip2.order_id = nil
          @her_tip2.check_id = nil
          response.body.should include(@her_tip2.to_json)
          @her_tip2.order_id = order_id
          @her_tip2.check_id = check_id
        end
        
        it 'assigns all tips' do
          get :index
          tips = assigns(:tips)
          tips.include?(@her_tip2).should be_true
          tips.include?(@her_tip1).should be_true
          tips.include?(@my_tip).should be_true
          tips.first.order_id.should be_nil
          tips.first.check_id.should be_nil
        end
      end
    end

    describe 'new' do
      describe '/tips/new' do
        it '302 to signin' do
          get :new
          response.status.should == 401
        end

        it '401 when json requested' do
          get :new, format: :js
          response.status.should == 401
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it '302 to signin' do
          proc do
            post :create
            response.status.should == 401
          end.should_not change(Tip, :count)
        end
      end
    end

    describe 'show' do
      describe '/tips/:id' do
        it 'responds to .json' do
          get :show, id:@my_tip.id, format: :json
          response.should be_success
          order_id = @my_tip.order_id
          check_id = @my_tip.check_id
          @my_tip.order_id = nil
          @my_tip.check_id = nil
          response.body.should include(@my_tip.to_json)
          @my_tip.order_id = order_id
          @my_tip.check_id = check_id
        end
        
        it 'should display a tip', :broken do
          get :show, id:@my_tip.id
          assigns(:tip).should eq(@my_tip)
          tip = assigns(:tip)
          tip.order_id.should be_nil
          tip.check_id.should be_nil
        end
      end
    end

    describe 'edit' do
      describe '/tips/:id/edit' do
        it '302 to signin' do
          get :edit, id:@my_tip.id
          response.status.should == 401
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips/:id' do
        it '302 to signin' do
          put :update, id:@my_tip.id, tip:{url:'laskdjf'}
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it '302 to signin' do
          proc do
            delete :destroy, id:@my_tip.id
            response.status.should == 401
          end.should_not change(Tip,:count)
        end
      end
    end
  end
end
