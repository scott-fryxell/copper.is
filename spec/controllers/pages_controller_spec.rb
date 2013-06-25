require 'spec_helper'

describe PagesController do
  describe 'as Guest' do
    before do
      mock_page
      controller.instance_eval do
        @current_user = nil
      end
    end

    describe 'index' do

      describe '/pages' do
        it 'assigns pages in created order' do pending
          @page1 = create!(:page,author_state:'adopted')
          @page2 = create!(:page,author_state:'adopted')

          get :index, format: :json
          assigns(:pages).should_not be_nil
          assigns(:pages).should eq([@page1, @page2])
        end
      end
    end

    describe 'show' do

      describe '/pages/:id' do
        it 'should assign a given page' do
          @page1 = create!(:page,author_state:'adopted')
          get :show, id:@page1.id
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end
  end

  describe 'as Fan' do
    before :each do
      mock_user
      @me = create!(:user)
    end

    describe 'index' do
      describe '/pages' do
        it 'should respond with not allowed' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/pages/:id' do
        it 'assigns a given page' do
          mock_page
          @page1 = create!(:page,author_state:'adopted')
          get_with @me, :show, id:@page1.id
          assigns(:page).id.should == @page1.id
          response.status.should == 200
        end
      end
    end

    describe 'update' do
      describe 'PUT /pages/:id' do
        it 'should respond with not allowed' do
          @page1 = create!(:page,author_state:'adopted')
          post_with @me, :update, page:{url:'http://twitter.com/_ugly'}, id:@page1.id
          response.status.should == 403
        end
      end
    end
  end
  describe 'as admin' do
    before :each do
      mock_user
      @me = create!(:admin)
    end

    describe 'index' do
      describe '/pages' do
        it 'assigns pages in created order' do pending
          @page1 = create!(:page,author_state:'adopted')
          @page2 = create!(:page,author_state:'adopted')
          get_with @me, :index
          response.status.should == 200
          assigns(:pages).should_not be_nil
          assigns(:pages).should eq([@page1, @page2])
        end
      end
    end

    it "should be able reject a page state" do
      @page1 = create!(:page,author_state:'adopted')
      post_with @me, :reject
      assigns(:pages).should_not be_nil
    end
  end
end
