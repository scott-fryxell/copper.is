require 'spec_helper'

describe UsersController do
  create_me_her_db
  
  describe 'as Guest' do
    before do
      unauthenticate
    end
    
    describe 'index' do
      describe '/users' do
        it 'renders a list of featured users' do
          get :index
          response.should redirect_to(root_path)
        end
      end
    end
    
    describe 'new' do
      describe '/users/new' do
        it 'redirects to home page' do
          get :new
          response.should redirect_to(root_path)
        end
      end
    end
    
    describe 'create'do
      describe 'POST /users' do
        post :create
        response.should redirect_to(root_path)
      end
    end
    
    describe 'show' do
      describe '/users/1'
      describe '/users/1'
    end
    
    describe 'edit' do
      it '/users/1/edit'  do
        get :new
        response.should redirect_to(root_path)
      end
    end
    
    describe 'update' do
      it 'PUT /users/1'  do
        get :new
        response.should redirect_to(root_path)
      end
    end
    
    describe 'destroy' do
      it 'DELETE /users/1'  do
        get :new
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe 'as Patron' do
    before do
      authenticate_as_patron @me
    end
    
    describe 'index' do
      describe '/users' do
        it 'renders a list of featured users'  do
          get :index
          response.should redirect_to(root_path)
        end
      end
      
      describe '/users?q=mike'
    end
    
    describe 'new' do
      describe '/u/new'
    end
    
    describe 'create' do
      describe 'POST /users'
    end
    
    describe 'edit' do
      describe '/users/:id' do
        it 'assigns user for current user only' do
          get :edit, id:@me.id
          response.should.state == 200
          assigns(:user).id.should == @me.id
        end
        
        it 'redirects to home page for an id that is not current user' do
          get :edit, id:@her.id
          response.should redirect_to(root_path)
        end
      end
      
      describe '/users/current' do
        it 'assigns user for current user only' do
          get :show, id:@me.id
          response.should.state == 200
          assigns(:user).id.should == @me.id
        end
      end
    end
    
    describe 'show' do
      describe '/users/current/edit'
      describe '/users/:id/edit'
    end
    
    describe 'update' do
      describe 'POST /users/current' do 
        it 'updates email'
        it 'update name'
        it 'updates address'
        it 'updates default tip amount'
      end
      
      describe 'POST /users/1' do
        it 'updates email'
        it 'update name'
        it 'update address'
        it 'updates default tip amount'
      end
    end
    
    describe 'destroy' do
      describe 'DELETE /users/current' do
        it 'redirects to home page'
      end
      
      describe 'DELETE /users/:id' do 
        it 'redirects to home page'
      end
    end
  end
  
  describe 'as Admin' do
    before :all do
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
