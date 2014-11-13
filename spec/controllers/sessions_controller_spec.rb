require 'spec_helper'

describe SessionsController, :type => :controller do
  before :each do
    me_setup
  end

  it 'should create a new account', :vcr do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    expect(User).to receive(:create_with_omniauth).and_return(create!(:user))
    get :create, provider:"facebook"
  end

  it 'create a second account' do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    get_with @me, :create, provider:"twitter"
  end

  it 'Should log the user out' do
    delete_with @me, :destroy
  end

  it 'Should log the user out' do
    delete_with @me, :destroy, redirect_to:"/trending"
  end

  it 'handle a login failure'

end
