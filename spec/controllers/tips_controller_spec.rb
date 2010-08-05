require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipsController do
  fixtures :users, :roles_users, :addresses, :accounts, :transactions, :pages, :sites, :locators, :tip_bundles, :refills, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites
  setup :activate_authlogic

  def user_session
    UserSession.create(users(:active))
  end

  describe "User with an active tip bundle" do
    before(:each) do
      @user = user_session
    end

    describe "the index action" do
      before(:each) do
        get :index
      end
      
      it "should return a list of active tips" do
        assigns['tips'].size.should == 8
      end

    end

  end

end