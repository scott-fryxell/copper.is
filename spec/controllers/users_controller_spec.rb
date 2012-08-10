require 'spec_helper'

describe UsersController do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do
      describe '/fans' do
        it 'responds with status 401' do
          get :index
          response.status.should == 401
        end
      end
    end

    describe 'new' do
      describe '/fans/new' do
        it 'responds with status 401' do
          get :new
          response.status.should == 401
        end
      end
    end

    describe 'create'do
      describe 'POST /fans' do
        it 'responds with status 401' do
          post :create
          response.status.should == 401
        end
      end
    end

    describe 'show' do
      describe '/fans/1'
      describe '/fans/1'
    end

    describe 'edit' do
      it '/fans/1/edit'  do
        get :new
        response.status.should == 401
      end
    end

    describe 'update' do
      it 'PUT /fans/1'  do
        get :new
        response.status.should == 401
      end
    end

    describe 'destroy' do
      it 'DELETE /fans/1'  do
        get :new
        response.status.should == 401
      end
    end
  end

  describe 'as Fan' do
    before :each do
      @me = create!(:user)
    end
    describe 'index' do
      describe '/fans' do
        it 'responds with status 403' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /fans'
    end
    

    describe 'edit' do
      describe '/fans/:id/edit' do
        it 'assigns user for current user only' do
          get_with @me, :edit, id:@me.id
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end

        it 'responds with a 403 for an id that is not current user' do
          @her = create!(:user_phony)
          get_with @me, :edit, id:@her.id
          response.status.should == 403
        end
      end

      describe '/fans/me/edit' do
        it 'assigns user for current user only' do
          get_with @me, :edit, id:'me'
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
    end

    describe 'show' do
      describe '/fans/me' do
        it 'assigns user with id me' do
          get_with @me, :show, id:'me'
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
      describe '/fans/:id' do
        it 'assigns user with id current' do
          get_with @me, :show, id:'me'
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
    end

    describe 'update' do
      describe 'PUT /fans/me' do
        it 'updates email' do
          put_with @me, :update, id:'me', user:{email:'dude@place.com'}
          @me.reload
          @me.email.should == 'dude@place.com'
        end

        it 'update name' do
          put_with @me, :update, id:'me', user:{name:'the man'}
          @me.reload
          @me.name.should == 'the man'
        end

        it 'updates default tip amount' do
          put_with @me, :update, id:'me', user:{tip_preference_in_cents:500}
          @me.reload
          @me.tip_preference_in_cents.should == 500
        end
      end

      describe 'PUT /fans/1' do
        describe 'me' do
          it 'updates email' do
            put_with @me, :update, id:@me.id, user:{email:'dude@place.com'}
            @me.reload
            @me.email.should == 'dude@place.com'
            response.status.should == 200
          end

          it 'update name' do
            put_with @me, :update, id:@me.id, user:{name:'the man'}
            @me.reload
            @me.name.should == 'the man'
            response.status.should == 200
          end

          it 'updates address'

          it 'updates default tip amount' do
            put_with @me, :update, id:@me.id, user:{tip_preference_in_cents:500}
            @me.reload
            @me.tip_preference_in_cents.should == 500
            response.status.should == 200
          end
        end

        describe 'her' do
          before :each do
            @her = create!(:user_phony)
          end
          it 'does not update email' do
            put_with @me, :update, id:@her.id, user:{email:'dude@place.com'}
            @her.reload
            @her.email.should_not == 'dude@place.com'
            response.status.should == 403
          end

          it 'does not update name' do
            put_with @me, :update, id:@her.id, user:{name:'the man'}
            @her.reload
            @her.name.should_not == 'the man'
            response.status.should == 403
          end


          it 'does not update tip amount' do
            put_with @me, :update, id:@her.id, user:{tip_preference_in_cents:500}
            @her.reload
            @her.tip_preference_in_cents.should_not == 500
            response.status.should == 403
          end
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /fans/me' do
        it 'responds with 403' do
          delete_with @me, :destroy, id:'me'
          response.status.should == 403
        end
      end

      describe 'DELETE /fans/:id' do
        it 'can not delete your self' do
          delete_with @me, :destroy, id:@me.id
          response.status.should == 403
        end

        it 'cannot delete another user' do
          @her = create!(:user_phony)
          delete_with @me, :destroy, id:@her.id
          response.status.should == 403
        end
      end
    end
  end
end
