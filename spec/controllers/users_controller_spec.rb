require 'spec_helper'

describe UsersController do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do
      describe '/users' do
        it 'responds with status 401' do
          get :index
          response.status.should == 401
        end
      end
    end

    describe 'new' do
      describe '/users/new' do
        it 'responds with status 401' do
          get :new
          response.status.should == 401
        end
      end
    end

    describe 'create'do
      describe 'POST /users' do
        it 'responds with status 401' do
          post :create
          response.status.should == 401
        end
      end
    end

    describe 'show' do
      describe '/users/1'
      describe '/users/1'
    end

    describe 'edit' do
      it '/users/1/edit'  do
        get :new
        response.status.should == 401
      end
    end

    describe 'update' do
      it 'PUT /users/1'  do
        get :new
        response.status.should == 401
      end
    end

    describe 'destroy' do
      it 'DELETE /users/1'  do
        get :new
        response.status.should == 401
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
      describe '/users' do
        it 'responds with status 403' do
          get :index
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /users'
    end

    describe 'edit' do
      describe '/users/:id/edit' do
        it 'assigns user for current user only' do
          get :edit, id:@me.id
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end

        it 'responds with a 403 for an id that is not current user' do
          get :edit, id:@her.id
          response.status.should == 403
        end
      end

      describe '/users/me/edit' do
        it 'assigns user for current user only' do
          get :edit, id:'me'
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
    end

    describe 'show' do
      describe '/users/me' do
        it 'assigns user with id me' do
          get :show, id:'me'
          response.status.should == 200
          p assigns(:user)
          p @me
          assigns(:user).id.should == @me.id
        end
      end
      describe '/users/:id' do
        it 'assigns user with id current' do
          get :show, id:'me'
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
    end

    describe 'update' do
      describe 'PUT /users/me' do
        it 'updates email' do
          put :update, id:'me', user:{email:'dude@place.com'}
          @me.reload
          @me.email.should == 'dude@place.com'
        end

        it 'update name' do
          put :update, id:'me', user:{name:'the man'}
          @me.reload
          @me.name.should == 'the man'
        end

        it 'updates default tip amount' do
          put :update, id:'me', user:{tip_preference_in_cents:500}
          @me.reload
          @me.tip_preference_in_cents.should == 500
        end
      end

      describe 'PUT /users/1' do
        describe 'me' do
          it 'updates email' do
            put :update, id:@me.id, user:{email:'dude@place.com'}
            @me.reload
            @me.email.should == 'dude@place.com'
            response.status.should == 200
          end

          it 'update name' do
            put :update, id:@me.id, user:{name:'the man'}
            @me.reload
            @me.name.should == 'the man'
            response.status.should == 200
          end

          it 'updates address'

          it 'updates default tip amount' do
            put :update, id:@me.id, user:{tip_preference_in_cents:500}
            @me.reload
            @me.tip_preference_in_cents.should == 500
            response.status.should == 200
          end
        end

        describe 'her' do
          it 'does not update email' do
            put :update, id:@her.id, user:{email:'dude@place.com'}
            @her.reload
            @her.email.should_not == 'dude@place.com'
            response.status.should == 403
          end

          it 'does not update name' do
            put :update, id:@her.id, user:{name:'the man'}
            @her.reload
            @her.name.should_not == 'the man'
            response.status.should == 403
          end


          it 'does not update tip amount' do
            put :update, id:@her.id, user:{tip_preference_in_cents:500}
            @her.reload
            @her.tip_preference_in_cents.should_not == 500
            response.status.should == 403
          end
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /users/me' do
        it 'responds with 403' do pending
          delete :destroy, id:'me'
          response.status.should == 403
        end
      end

      describe 'DELETE /users/:id' do
        it 'redirects to home page' do pending
          delete :destroy, id:@me.id
          response.status.should == 403
        end

        it 'redirects to home page' do pending
          delete :destroy, id:@her.id
          response.status.should == 403
        end
      end
    end
  end
end
