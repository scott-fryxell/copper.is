require 'spec_helper'

describe CardsController do
  before :each do
    user = @me
    controller.instance_eval do
      cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
      @current_user = user
    end
  end

  describe 'show' do
    it 'responds to .json' do
      get :show, format: :json
      response.should be_success
    end
  end

  describe 'update' do
    it 'responds to .json' do
      put :update, format: :json
      response.status.should == 200
      response.should be_success
    end
  end

  describe 'create' do
    it 'responds to .json' do
      post :create, format: :json
      response.status.should == 200
      response.should be_success
    end
  end

end
