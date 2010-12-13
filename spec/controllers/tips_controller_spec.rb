require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipsController do
  fixtures :users, :roles_users, :pages, :sites, :locators, :tip_bundles, :tips, :royalty_bundles, :tip_royalties, :royalty_bundles_sites
  setup :activate_authlogic

  def user_session_with_funds
    UserSession.create(users(:active))
  end

  def user_session_with_no_funds
    UserSession.create(users(:patron))
  end

  describe "User with an active tip bundle" do
    before(:each) do
      @user = user_session_with_funds
    end

    describe "the index action" do
      before(:each) do
        get :index
      end

      it "should return a list of active tips" do
        assigns['tips'].size.should == 8
      end
    end

    describe "the create action" do
      before(:each) do
        post :create, :tip => {:uri => "http://thisisfun.net"}
      end

      it "should redirect back to the tip page" do
        response.should redirect_to(tips_url)
        response.should redirect_to(:action => 'index')
      end

      it "should thank the user for making the tip with flash" do
        flash[:notice].should contain("Tip successfully created.")
      end

    end
  end

end