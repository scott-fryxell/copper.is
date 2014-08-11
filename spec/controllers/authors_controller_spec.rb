require 'spec_helper'

describe AuthorsController do
  before :each do
    me_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it 'Should let the user manage their facebook pages' do
    put_with @me, :can_view_facebook_pages, id:@my_tip.id
  end

  it 'let the user give permission to publish on their timeline' do
    put_with @me, :can_post_to_facebook, id:@my_tip.id
  end

end
