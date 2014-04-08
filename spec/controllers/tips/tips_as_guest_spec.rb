require 'spec_helper'

describe TipsController do
  describe 'as Guest' do

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
