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

    it "should not be able to change page state" do
      @page = create!(:page,author_state:'manual')
      post :reject, id:@page.id
      response.status.should == 401
      @page.reload
      @page.dead?.should == false
    end
  end

  describe 'as Fan' do
    before :each do
      mock_user
      mock_page
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

    it "should not be able to change page state" do
      @page = create!(:page,author_state:'manual')
      post_with @me, :reject, id:@page.id
      response.status.should == 403
      @page.reload
      @page.dead?.should == false
    end
  end

  describe 'as Admin' do
    before :each do
      mock_page_and_user
      @admin = create!(:admin)
    end

    describe 'index' do
      describe '/pages' do
        it 'should show pages that have charged tips and need attention' do
          Tip.count.should == 0
          @page1 = create!(:page,author_state:'manual')
          @page2 = create!(:page,author_state:'manual')
          @tip1 = create!(:tip, paid_state:'charged', page_id:@page1.id)
          @tip1 = create!(:tip, paid_state:'charged', page_id:@page2.id )
          Tip.count.should == 2
          get_with @admin, :index
          response.status.should == 200
          assigns(:pages).should_not be_nil
          assigns(:pages).should eq([@page1, @page2])
        end
      end
    end

    describe 'update' do
      describe '/pages/:id' do

        it "can update a page url and title" do
          @page = create!(:page,author_state:'manual')
          post_with @admin, :update, id:@page.id, url:'http://example.com', title:"raddest internet thing ever",
          nsfw:'true', trending:'true', welcome:'true', onboarding:'true'
          assigns(:page).id.should == @page.id
          response.status.should == 200
          @page.reload
          @page.url.should == "http://example.com"
          @page.title.should =="raddest internet thing ever"
          @page.nsfw.should  be_true
          @page.trending.should  be_true
          @page.welcome.should  be_true
          # @page.trending.should  be_true
          @page.onboarding.should  be_true

        end

        it "can reject a page" do
          @page = create!(:page,author_state:'manual')
          post_with @admin, :reject, id:@page.id
          assigns(:page).id.should == @page.id
          response.status.should == 200
          @page.reload
          @page.dead?.should == true
        end

      end
    end


  end
end
