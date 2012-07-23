require 'spec_helper'

describe IdentitiesController do
  describe 'as Guest' do
    describe 'index' do
      describe '/identities' do
        it '401' do
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
        it '401 for random identities' do
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

        it 'should let a guest see an identity that\'s wanted' do
          twitter = FactoryGirl.create(:identities_twitter,identity_state: :wanted)
          get :edit, id:twitter.id
          response.status.should == 200
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

    describe 'index' do
      describe '/identities' do
        it 'assigns all identities for current user' do pending
          get_with @me, :index, format: :json
          response.should be_success
          assigns(:identities).size.should == 1
          response.status.should == 200
        end
      end
    end

    describe 'new' do
      describe '/identities/new' do
        it '403' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/identities/:id' do

        it 'assigns the identity' do pending
          get_with @me, :show, id:@my_identity.id, format: :json
          response.should be_success
          assigns(:identity).id.should == @my_identity.id
        end

        it '401 for another user\'s identity' do pending
          get_with @me, :show, id:@her_identity.id, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'edit' do
      describe '/identities/:id/edit' do
        it '403' do pending
          get_with @me, :edit, id:@my_identity.id, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /identities/:id' do
        it '403' do pending
          get_with @me, :edit, id:@my_identity.id
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
