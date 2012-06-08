require 'spec_helper'

describe ChecksController, :broken do
  describe 'as Guest' do
    before do
      controller.instance_eval do
        @current_user = nil
      end
    end
    describe 'index' do
      describe '/checks' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'new' do
      describe '/checks/new' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'create' do
      describe 'POST /checks' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'show' do
      describe '/checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe '/checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'edit' do
      describe '/checks/:id/edit' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe '/checks/current/edit' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'update' do
      describe 'PUT /checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe 'PUT /checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
    describe 'destroy' do
      describe 'DELETE /checks/:id' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
      describe 'DELETE /checks/current' do
        it '302' do
          get :index
          response.should redirect_to(signin_path)
        end
      end
    end
  end

  describe 'as Patron' do
    before :all do
    end
    
    before :each do
      @check = FactoryGirl.create(:check,user:@me)
      @check_paid = FactoryGirl.create(:check_paid,user:@me)
      @check_cashed = FactoryGirl.create(:check_cashed,user:@me)
      @her_check = FactoryGirl.create(:check,user:@her)
      user = @me
      controller.instance_eval do
        cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
        @current_user = user
      end
    end

    describe 'index' do
      it 'responds to .json' do
        get :index, :format => :json
        response.should be_success
        response.body.should include(@check.to_json)
      end
      
      describe '/checks' do
        it 'assigns all checks for current user: earned, paid and cashed' do
          get :index
          response.status.should == 200
          assigns(:checks).include?(@check).should be_true
          assigns(:checks).include?(@check_paid).should be_true
          assigns(:checks).include?(@check_cashed).should be_true
        end
      end

      describe '/checks?s=earned' do
        it 'assigns just the current check for the current user' do
          get :index, s:'earned'
          response.status.should == 200
          assigns(:checks).include?(@check).should be_true
          assigns(:checks).include?(@check_paid).should_not be_true
          assigns(:checks).include?(@check_cashed).should_not be_true
        end
      end

      describe '/checks?s=paid' do
        it 'assigns all paid checks for current user' do
          get :index, s:'paid'
          response.status.should == 200
          assigns(:checks).include?(@check).should_not be_true
          assigns(:checks).include?(@check_paid).should be_true
          assigns(:checks).include?(@check_cashed).should_not be_true
        end
      end

      describe '/checks?s=cashed' do
        it 'assigns all declined checks for current user' do
          get :index, s:'cashed'
          response.status.should == 200
          assigns(:checks).include?(@check).should_not be_true
          assigns(:checks).include?(@check_paid).should_not be_true
          assigns(:checks).include?(@check_cashed).should be_true
        end
      end
    end

    describe 'new' do
      describe '/checks/new' do
        it '403' do
          get :new
          response.status.should == 403
        end
      end
    end

    describe 'create' do
      describe 'POST /checks' do
        it '403' do
          post :create
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/checks/:id' do
        it 'responds to .json' do
          get :show, id:@check_paid.id, format: :json 
          response.should be_success
          response.body.should include(@check_paid.to_json)
        end
        
        it 'renders the given check when owned by current user' do
          get :show, id:@check_paid.id
          response.status.should == 200
          assigns(:check).id.should == @check_paid.id
        end

        it '403 if check is not owned by current user' do
          get :show, id:@her_check.id
          response.status.should == 401
        end
      end
    end

    describe 'edit' do
      describe '/checks/:id/edit' do
        it '403' do
          get :edit, id:@check.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips_orders/:id' do
        it '403' do
          put :update, id:@check.id
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /checks/:id' do
        it '403' do
          delete :destroy, id:@check.id
          response.status.should == 403
        end
      end
    end
  end

  describe 'as Admin' do
    before do
      authenticate_as_admin
    end
    describe 'index'
    describe 'new'
    describe 'create'
    describe 'show'
    describe 'eddescribe'
    describe 'update'
    describe 'destroy'
  end
end

