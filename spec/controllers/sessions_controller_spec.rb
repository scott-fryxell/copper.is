require 'spec_helper'

describe SessionsController, :type => :controller do
  before :each do
    me_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'should create a new account' do
    # expect(controller.session["omniauth.auth"][:uid]).to eq('234567')
    expect(User).to receive(:create_with_omniauth).and_return(create!(:user))
    get :create, provider:"facebook"
  end

  it 'create a second account' do
    # expect(User).to receive(:create_with_omniauth).and_return(create!(:user))
    get_with @me, :create, provider:"facebook"
  end

  it 'Should log the user out' do
    delete_with @me, :destroy
  end

  it 'Should log the user out' do
    delete_with @me, :destroy, redirect_to:"/trending"
  end



  it 'handle a login failure' do
    post_with @me, :failure
  end

end
