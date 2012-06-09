require 'spec_helper'

describe PagesController do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do
      it 'responds to .json' do
        get :index, format: :json 
        response.should be_success
        response.body.should include(@page1.to_json)
      end
      
      describe '/pages' do
        it 'assigns pages in created order' do
          get :index
          assigns(:pages).include?(@page1).should be_true
          assigns(:pages).include?(@page2).should be_true
        end
      end
    end

    describe 'new' do
      describe '/pages/new' do
        it '302 to signin' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end

    describe 'create' do
      describe 'POST /pages' do
        it '302 in signin' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end

    describe 'show' do
      it 'responds to .json' do
        get :show, id:@page1.id, format: :json 
        response.should be_success
        response.body.should include(@page1.to_json)
      end
      
      describe '/pages/:id' do
        it 'assigns a given page' do
          get :show, id:@page1.id
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end

    describe 'edit' do
      describe '/pages/:id/edit' do
        it '302 in signin' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end

    describe 'update' do
      describe 'PUT /pages/:id' do
        it '302s to signin page' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it '302s to signin page' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end
  end

  describe 'as Patron' do
    before :each do
      user = @me
      controller.instance_eval do
        cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
        @current_user = user
      end
    end

    describe 'index' do
      describe '/pages' do
        it 'responds to .json' do
          get :index, format: :json 
          response.should be_success
          response.body.should include(@page1.to_json)
        end
        
        it 'assigns pages in created order' do
          get :index
          assigns(:pages).include?(@page1).should be_true
          assigns(:pages).include?(@page2).should be_true
        end
      end
    end

    describe 'new' do
      describe '/pages/new' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /pages' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/pages/:id' do
        it 'responds to .json' do
          get :show, id:@page1.id, format: :json 
          response.should be_success
          response.body.should include(@page1.to_json)
        end
        
        it 'assigns a given page' do
          get :show, id:@page1.id
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end

    describe 'edit' do
      describe '/pages/:id/edit' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /pages/:id' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end
  end

  describe 'as Admin' do
    before do
      authenticate_as_admin
    end
    describe 'index'
    describe 'new'
    describe 'create'
    describe 'show'
    describe 'edit'
    describe 'update'
    describe 'destroy'
  end
end
