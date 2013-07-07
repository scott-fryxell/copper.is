require 'spec_helper'

describe ChecksController do
  describe 'as Guest' do

    describe 'index' do
      describe '/checks' do
        it 'should reply with a 401'do
          get :index
          response.status.should == 401
        end
      end
    end
    describe 'show' do
      describe '/checks/:id' do
        it 'should reply with a 401' do
          get :index
          response.status.should == 401
        end
      end
    end
  end

  describe 'as Fan' do
    before :each do
      me_setup
      her_setup
      @check = FactoryGirl.create(:check,user:@me)
      @check_paid = FactoryGirl.create(:check_paid,user:@me)
      @check_cashed = FactoryGirl.create(:check_cashed,user:@me)
      @her_check = FactoryGirl.create(:check,user:@her)
    end

    describe 'index' do

      describe '/checks' do
        it 'assigns all checks for current user: earned, paid and cashed' do
          get_with @me, :index, :format => :json
          response.should be_success
          response.status.should == 200
          assigns(:checks).include?(@check).should be_true
          assigns(:checks).include?(@check_paid).should be_true
          assigns(:checks).include?(@check_cashed).should be_true
        end
      end

      describe '/checks?s=earned' do
        it 'assigns just the current check for the current user' do
          get_with @me, :index, s:'earned', :format => :json
          response.status.should == 200
          assigns(:checks).include?(@check).should be_true
          assigns(:checks).include?(@check_paid).should_not be_true
          assigns(:checks).include?(@check_cashed).should_not be_true
        end
      end

      describe '/checks?s=paid' do
        it 'assigns all paid checks for current user' do
          get_with @me, :index, s:'paid', :format => :json
          response.status.should == 200
          assigns(:checks).include?(@check).should_not be_true
          assigns(:checks).include?(@check_paid).should be_true
          assigns(:checks).include?(@check_cashed).should_not be_true
        end
      end

      describe '/checks?s=cashed' do
        it 'assigns all declined checks for current user' do
          get_with @me, :index, s:'cashed', :format => :json
          response.status.should == 200
          assigns(:checks).include?(@check).should_not be_true
          assigns(:checks).include?(@check_paid).should_not be_true
          assigns(:checks).include?(@check_cashed).should be_true
        end
      end
    end

    describe 'show' do
      describe '/checks/:id' do
        it 'renders the given check when owned by current user' do
          get_with @me, :show, id:@check_paid.id, format: :json
          response.status.should == 200
          response.should be_success
          assigns(:check).id.should == @check_paid.id
        end

        it '401 if check is not owned by current user' do
          get_with @me, :show, id:@her_check.id, format: :json
          response.status.should == 401
        end
      end
    end
  end
end
