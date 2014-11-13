require 'spec_helper'

describe PagesController, :type => :controller do
  before :each do
    me_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'displays a single page' do
    get :show, id:@page1.id
  end

  it 'has an appcache ' do
    get :member_appcache, id:@page1.id
  end

  it 'has an collection appcache ' do
    get :collection_appcache
  end

end
