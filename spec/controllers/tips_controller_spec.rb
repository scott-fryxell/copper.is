require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipsController do
  fixtures :roles, :users, :roles_users, :pages, :sites, :locators, :tip_bundles, :tips, :royalty_bundles, :tip_royalties
  setup :activate_authlogic

  describe "User with an active tip bundle" do
    describe "the index action" do
      before(:each) do
        without_access_control do
          UserSession.create(users(:a_fan))
          get :index
        end
      end

      it "should return a list of active tips" do
        assigns['tips'].size.should == 8
      end
    end

    describe "the create action" do
      before(:each) do
        without_access_control do
          UserSession.create(users(:a_fan))
          post :create, :tip => {:uri => "http://thisisfun.net"}
        end
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