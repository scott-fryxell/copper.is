require 'spec_helper'

describe AuthorsController do

  describe 'as Guest' do
    before :each do
      mock_page_and_user
      @author = create!(:author_twitter)
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
          get :show, id:@author.id
          assigns(:author).id.should == @author.id
          response.status.should == 401
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '401' do
          post :update, id:@author.id
          response.status.should == 401
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it '401' do
          delete :destroy, id:@author.id
          response.status.should == 401
        end
      end
    end

    describe 'enquire' do
      it 'should display information for a known author' do
        Author.count.should == 1
        get :enquire, provider:@author.provider, username:@author.username
        assigns(:author).id.should == @author.id
        response.status.should == 200
        Author.count.should == 1
      end
      it 'should display info for unknown authors' do
        Author.count.should == 1
        get :enquire, provider:"soundcloud", username:"brokenbydawn"
        assigns(:author).provider.should == "soundcloud"
        assigns(:author).username.should == "brokenbydawn"
        response.status.should == 200
        Author.count == 2
      end
      it 'should 404 for invalid authors' do
        Author.count.should == 1
        get :enquire, provider:"made_up", username:"author"
        Author.count.should == 1
        response.status.should == 404
      end
    end
  end

  describe 'as Fan' do
    before :each do
      me_setup
      @author = create!(:author_phony)
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
          get_with @me, :show, id:@author.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '403' do
          put_with @me, :update, id:@author.id
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it 'destroys the given author' do
          proc do
            delete_with @me, :destroy, id:@author.id
          end.should_not change(Author, :count)
          response.status.should == 403
        end
      end
    end
  end

  describe 'as Admin', :broken do
    before :each do
      me_setup
      @author = create!(:author)
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
          get_with @me, :show, id:@author.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /authors/:id' do
        it '403' do
          put_with @me, :update, id:@author.id
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /authors/:id' do
        it 'destroys the given author' do
          proc do
            delete :destroy, id:@author.id
          end.should_not change(Author, :count)
          response.status.should == 403
        end
      end
    end
  end

end
