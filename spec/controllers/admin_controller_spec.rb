require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe AdminController do
  fixtures :users, :roles_users
  setup :activate_authlogic
  
  def admin_user_session
    UserSession.create(users(:admin_user))
  end
  
  before(:each) do
    @admin = admin_user_session
  end
  
  it "home action should display the admin home page" do
    get :home
    response.should render_template('home')
  end
  
end