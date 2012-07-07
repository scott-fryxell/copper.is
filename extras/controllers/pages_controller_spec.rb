require 'spec_helper'

describe PagesController, :broken do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do

      describe '/pages' do
        it 'assigns pages in created order' do pending
          get :index, format: :json
          assigns(:pages).include?(@page1).should be_true
          assigns(:pages).include?(@page2).should be_true
        end
      end
    end

    describe 'new' do
      describe '/pages/new' do
        it 'return not authorized' do
          get :new, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'create' do
      describe 'POST /pages' do
        it 'return not authorized' do
          get :new, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'show' do

      describe '/pages/:id' do
        it 'should assign a given page' do
          get :show, id:@page1.id, format: :json
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end

    describe 'edit' do
      describe '/pages/:id/edit' do
        it 'should respond with not authorized' do
          get :new, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'update' do
      describe 'PUT /pages/:id' do
        it 'should respond with not authorized' do
          get :new, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it 'should respond with not authorized' do
          get :new, format: :json
          response.status.should == 401
        end
      end
    end
  end

  describe 'as Fan' do

    describe 'index' do
      describe '/pages' do
        it 'assigns pages in created order' do pending
          get_with @me, :index, format: :json
          response.status.should == 200
          assigns(:pages).include?(@page1).should be_true
          assigns(:pages).include?(@page2).should be_true
        end
      end
    end

    describe 'new' do
      describe '/pages/new' do
        it 'should respond with not allowed' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /pages' do
        it 'should respond with not allowed' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/pages/:id' do
        it 'assigns a given page' do
          get_with @me, :show, id:@page1.id, format: :json
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end

    describe 'edit' do
      describe '/pages/:id/edit' do
        it 'should respond with not allowed' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /pages/:id' do
        it 'should respond with not allowed' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it 'should respond with not allowed' do
          get_with @me, :new
          response.status.should == 403
        end
      end
    end
  end
end
