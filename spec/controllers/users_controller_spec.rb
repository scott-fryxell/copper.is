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

    describe 'show' do
      it 'GET /users/1' do
        mock_user
        @a_fan = create!(:user)
        get :show, id:@a_fan.id
        response.status.should == 401
      end
    end

    describe 'update' do
      it 'PUT /users/1' do
        mock_user
        @a_fan = create!(:user)
        put :update, id:@a_fan.id
        response.status.should == 401
      end
    end
  end

  describe 'as Fan' do
    before :each do
      mock_user
      @me = create!(:user)
    end
    describe 'index' do
      describe '/users' do
        it 'responds with status 403' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/users/:id' do
        it 'assigns user with id current' do
          get_with @me, :show, id:'me', format: :json
          response.status.should == 200
          assigns(:user).id.should == @me.id
        end
      end
    end

    describe 'update' do

      describe 'PUT /users/1' do
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
  end
end
