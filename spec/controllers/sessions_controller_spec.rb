require 'spec_helper'

describe SessionsController do
  before :each do
    me_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'should let them log in' do pending
    controller.session["omniauth.auth"][:uid].should == '234567'
    post :create
  end

  it 'Should log the user out' do
    delete_with @me, :destroy
  end

  it 'handle a login failure' do
    post_with @me, :failure
  end

end
