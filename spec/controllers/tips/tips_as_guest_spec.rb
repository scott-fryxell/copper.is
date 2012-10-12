require 'spec_helper'

describe TipsController do
  describe 'as Guest' do

    describe 'index' do
      describe '/tips' do

        it 'assigns all tips' do
          her_setup
          me_setup
          get :index, format: :json
          tips = assigns(:tips)
          tips.include?(@her_tip2).should be_true
          tips.include?(@her_tip1).should be_true
          tips.include?(@my_tip).should be_true
        end
      end
    end

    describe 'new' do
      describe '/tips/new' do
        it 'should respond with 200' do
          get :new
          response.status.should == 200
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it 'should respond with 401' do
          proc do
            post :create
            response.status.should == 401
          end.should_not change(Tip, :count)
        end
      end
    end

    describe 'show' do
      describe '/tips/:id' do
        it 'should display a tip' do 
          me_setup
          get :show, id:@my_tip.id, format: :json
          assigns(:tip).should eq(@my_tip)
          tip = assigns(:tip)
          response.should be_success
        end
      end
    end

    describe 'edit' do
      describe '/tips/:id/edit' do
        it 'respond with not authorized' do
          me_setup
          get :edit, id:@my_tip.id, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips/:id' do
        it 'respond with not authorized' do
          me_setup
          put :update, id:@my_tip.id, tip:{url:'laskdjf'}
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it 'should respond with not authorized' do
          me_setup
          proc do
            delete :destroy, id:@my_tip.id
            response.status.should == 401
          end.should_not change(Tip,:count)
        end
      end
    end
  end
end
