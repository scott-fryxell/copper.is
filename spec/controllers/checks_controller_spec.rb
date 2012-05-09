require 'spec_helper'

describe ChecksController do
  create_me_her_db_with_orders
  
  describe 'as Guest' do
    before do
      unauthenticate
    end
    describe 'index' do
      describe '/checks' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'new' do
      describe '/checks/new' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'create' do
      describe 'POST /checks' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'show' do
      describe '/checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe '/checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'edit' do
      describe '/checks/:id/edit' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe '/checks/current/edit' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'update' do
      describe 'PUT /checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe 'PUT /checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe 'DELETE /checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
  end
  
  describe 'as Patron' do
    before do
      authenticate_as_patron @me
    end
    
    describe 'index' do
      describe '/checks' do
        it 'renders all checks for current user: earned, paid and cashed' do
          get :index
          response.status.should == 200
          assigns(:checks).should == [@check,@check_paid,@check_cashed]
        end
      end
      
      describe '/checks?s=earned' do
        it 'renders just the current check for the current user' do
          get :index, s:'earned'
          response.status.should == 200
          assigns(:checks).should == [@check]
        end
      end
      
      describe '/checks?s=paid' do
        it 'renders all paid checks for current user' do
          get :index, s:'paid'
          response.status.should == 200
          assigns(:checks).should == [@check_paid]
        end
      end
      
      describe '/checks?s=cashed' do
        it 'renders all declined checks for current user' do
          get :index, s:'cashed'
          response.status.should == 200
          assigns(:checks).should == [@check_cashed]
        end
      end
    end
    
    describe 'new' do
      describe '/checks/new' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end
    
    describe 'create' do
      describe 'POST /checks' do
        it '403' do
          post :create
          response.status.should == 403
        end
      end
    end
    
    describe 'show' do
      describe '/checks/:id' do
        it 'renders the given check when owned by current user' do
          get :show, id:@check_paid.id
          response.status.should == 200
          assigns(:check).id.should == @check_paid.id
        end
        
        it '403 if check is not owned by current user' do
          get :show, id:@her_check.id
          response.status.should == 401
        end
      end
    end
    
    describe 'edit' do
      describe '/checks/:id/edit' do
        it '403' do
          get :edit, id:@check.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips_orders/:id' do
        it '403' do
          put :update, id:@check.id
          response.status.should == 403
        end
      end
    end
    
    describe 'destroy' do
      describe 'DELETE /checks/:id' do
        it '403' do
          delete :destroy, id:@check.id
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
    describe 'eddescribe'
    describe 'update'
    describe 'destroy'
  end
end

