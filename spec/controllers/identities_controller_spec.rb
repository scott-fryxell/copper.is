require 'spec_helper'

describe IdentitiesController,:focus do
  create_me_her_db
  
  describe 'as Guest' do
    before do
      unauthenticate
    end
    describe 'index' do
      describe '/identities' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'new' do
      describe '/identities/new' do
        it '302' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'create' do
      describe 'POST /identities' do
        it 'does something',:broken do
          post :create
        end
      end
    end
    describe 'show' do
      describe '/identities/:id' do
        it '302' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'edit' do
      describe '/identities/:id/edit' do
        it '302' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'update' do
      describe 'PUT /identities/:id' do
        it '302' do
          get :new
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /identities/:id' do
        it '302' do
          get :new
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
      describe '/identities' do
        it 'assigns all identities for current user' do
          get :index
          assigns(:identities).size.should == 1 
          response.status.should == 200
        end
      end
    end
    
    describe 'new' do
      describe '/identities/new' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end
    
    describe 'create' do
      describe 'POST /identities' do
        it 'should be tested'
      end
    end
    
    describe 'show' do
      describe '/identities/:id' do
        it 'assigns the identity', :broken do
          get :show, id:@me.identities.first.id
          assigns(:identity).id.should == @me.identities.first.id
        end
        
        it '401 for another user\'s identity',:broken do
          get :show, id:@her.identities.first.id
          response.status.should == 401
        end
      end
    end
    
    describe 'edit', :broken do
      describe '/identities/:id/edit' do
        it '403' do
          get :edit, id:@me.identities.first.id
          response.status.should == 403
        end
      end
    end
    
    describe 'update', :broken do
      describe 'PUT /identities/:id' do
        it '403' do
          get :edit, id:@me.identities.first.id
          response.status.should == 403
        end
      end
    end
    
    describe 'destroy',:broken do
      describe 'DELETE /identities/:id' do
        it 'destroys the given identity' do
          proc do 
            delete :destroy, id:@me.identities.first.id
          end.should change(Identity, :count)
        end
      end
    end
  end
end
