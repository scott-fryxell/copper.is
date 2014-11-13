require 'spec_helper'

describe SessionsController, :type => :controller do
  let(:me) { create!(:user) }

  before :each do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'should create a new account' do
    expect(User).to receive(:create_with_omniauth).and_return(me)
    get :create, provider:'facebook'
  end

  it 'create a second account' do
    # expect(User).to receive(:create_with_omniauth).and_return(me)
    get_with me, :create, provider:"twitter", uid:'brokenbydawn'
  end

  it 'Should log the user out' do
    delete_with me, :destroy
  end

  it 'Should log the user out' do
    delete_with me, :destroy, redirect_to:"/trending"
  end

  it 'handle a login failure'

end
