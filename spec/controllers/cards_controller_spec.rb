require 'spec_helper'

describe CardsController do
  before :each do
    me_setup
  end

  describe 'show' do
    it 'responds to .json' do
      get_with @me, :show, format: :json
      response.should be_success
    end
  end

  describe 'update' do
    it 'responds to .json' do
      put_with @me, :update, format: :json
      response.status.should == 200
      response.should be_success
    end
  end

  describe 'create' do
    it 'responds to .json', :vcr do
      post_with @me, :create, format: :json  
      response.status.should == 200
      response.should be_success
    end
  end

end
