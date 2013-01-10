require 'spec_helper'

describe AuthorsController do
  describe 'as Guest' do
    describe 'index' do
      describe '/authors' do
        it '401' do
          get :index
          response.status.should == 401
        end
      end
    end
    describe 'new' do
      describe '/authors/new' do
        it '401' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'create' do
      describe 'POST /authors' do
        it 'does something' do
          post :create
          response.status.should == 401
        end
      end
    end
    describe 'show' do
      describe '/authors/:id' do
        it '401 for random authors' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'edit' do
      describe '/authors/:id/edit' do
        it '401' do
          get :new
          response.status.should == 401
        end

        it 'should let a guest see an author that\'s wanted' do
          twitter = FactoryGirl.create(:authors_twitter,identity_state: :wanted)
          get :edit, id:twitter.id
          response.status.should == 200
        end
      end
    end
    describe 'update' do
      describe 'PUT /authors/:id' do
        it '401' do
          get :new
          response.status.should == 401
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it '401' do
          get :new
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
        it 'assigns all authors for current user' do pending
          get_with @me, :index, format: :json
          response.should be_success
          assigns(:authors).size.should == 1
          response.status.should == 200
        end
      end
    end

    describe 'new' do
      describe '/authors/new' do
        it '403' do
          get_with @me, :new, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/authors/:id' do

        it 'assigns the author' do pending
          get_with @me, :show, id:@my_author.id, format: :json
          response.should be_success
          assigns(:author).id.should == @my_author.id
        end

        it '401 for another user\'s author' do pending
          her_setup
          get_with @me, :show, id:@her_author.id, format: :json
          response.status.should == 401
        end
      end
    end

    describe 'edit' do
      describe '/authors/:id/edit' do
        it '403' do pending
          @my_author = @me.authors.first
          get_with @me, :edit, id:@my_author.id, format: :json
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '403' do pending
          @my_author = @me.authors.first
          get_with @me, :edit, id:@my_author.id
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it 'destroys the given author' do pending
          proc do
            delete :destroy, id:@my_author.id
          end.should change(Author, :count)
        end
      end
    end
  end
end
