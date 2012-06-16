require 'spec_helper'

describe IdentitiesController do
  describe 'as Guest' do
    before :all do
      controller.instance_eval do
        @current_user = nil
      end
    end
    
    describe 'index' do
      describe '/identities' do
        it '302' do
          get :index
          response.status.should == 401
        end
      end
    end
    describe 'new' do
      describe '/identities/new' do
        it '302' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'create' do
      describe 'POST /identities' do
        it 'does something' do
          pending
          post :create
        end
      end
    end
    describe 'show' do
      describe '/identities/:id' do
        it '302' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'edit' do
      describe '/identities/:id/edit' do
        it '302' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'update' do
      describe 'PUT /identities/:id' do
        it '302' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /identities/:id' do
        it '302' do
          get :new
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

    describe 'index' do
      describe '/identities' do
        it 'responds to .json' do
          get :index, format: :json
          response.should be_success
        end
        
        it 'assigns all identities for current user' do
          pending
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

    describe 'show' do
      describe '/identities/:id' do
        it 'responds to .json' do pending
          get :show, id:@my_identity.id, format: :json 
          response.should be_success
          response.body.should include(@my_identity.to_json)
        end
        
        it 'assigns the identity' do pending
          get :show, id:@my_identity.id
          assigns(:identity).id.should == @my_identity.id
        end

        it '401 for another user\'s identity' do pending
          get :show, id:@her_identity.id
          response.status.should == 401
        end
      end
    end

    describe 'edit' do
      describe '/identities/:id/edit' do
        it '403' do pending
          get :edit, id:@my_identity.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /identities/:id' do
        it '403' do pending
          get :edit, id:@my_identity.id
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /identities/:id' do
        it 'destroys the given identity' do pending
          proc do
            delete :destroy, id:@my_identity.id
          end.should change(Identity, :count)
        end
      end
    end
  end
end
