require 'spec_helper'

describe AuthorsController do
  describe 'as Guest' do
    before :each do
      other_setup
    end

    describe 'index' do
      describe '/authors' do
        it '401' do
          get :index
          response.status.should == 401
        end
      end
    end
    describe 'show' do
      describe '/authors/:id' do
        it '401 for random authors' do
          get :show, id:@stranger.id
          assigns(:author).id.should == @stranger.id
          response.status.should == 200
        end
      end
    end
    describe 'update' do
      describe 'PUT /authors/:id' do
        it '401' do
          post :update, id:@stranger.id
          response.status.should == 401
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it '401' do
          delete :destroy, id:@stranger.id
          response.status.should == 401
        end
      end
    end
  end

  describe 'as Fan' do
    before :each do
      me_setup
    end

    describe 'index' do
      describe '/authors' do
        it 'assigns all authors for current user' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/authors/:id' do
        it '401 for another user\'s author' do
          other_setup
          get_with @me, :show, id:@stranger.id
          response.status.should == 200
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '403' do
          post_with @me, :update, id:666
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it 'destroys the given author' do
          proc do
            delete :destroy, id:@my_author.id
          end.should_not change(Author, :count)
        end
      end
    end
  end
end
