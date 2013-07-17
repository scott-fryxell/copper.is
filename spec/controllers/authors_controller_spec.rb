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
          get :show, id:@other.id
          assigns(:author).id.should == @other.id
          response.status.should == 401
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '401' do
          post :update, id:@other.id
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it '401' do
          delete :destroy, id:@other.id
          response.status.should == 401
        end
      end
    end

    describe 'enquire' do
      it 'should display information for an author' do
        get :enquire, id:"twitter/copper_is"
        assigns(:author).id.should == @other.id
        response.status.should == 200
      end
      it 'should display info for unknown authors' do
        Author.count.should ==1
        get :enquire, id:"soundcloud/brokenbydawn"
        # assigns(:author).provider.should == "soundcloud"
        # assigns(:author).username.should == "brokenbydawn"
        response.status.should == 200
        Author.count == 2
      end
      it 'should 404 for invalid authors' do
        get :enquire, id:"made_up/author"
        response.status.should == 404
      end
    end
  end

  describe 'as Fan' do
    before :each do
      me_setup
    end

    describe 'index' do
      describe '/authors' do
        it 'should not see authors index' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/authors/:id' do
        it '403' do
          other_setup
          get_with @me, :show, id:@my_author.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '403' do
          post_with @me, :update, id:@my_author.id
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
