require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  describe "when logging in with valid credentials" do
    fixtures :users, :roles_users

    before :each do
      post :create, :user => {:email => "test@test.com", :password => "test"}, :registered => "yes"
    end

    it "should redirect to another page" do
      response.should be_redirect
    end

    it "should return a message indicating success upon successful login" do
      flash[:notice].should contain("Successfully logged in")
    end

    it "should redirect the user to the default page for users, which is their tips list" do
      response.should redirect_to(tips_url)
    end
  end

  describe "when using 'Remember Me'" do
    it "should have a default session duration of 2 weeks" do
      session = UserSession.new
      session.remember_me = true
      session.remember_me_for.should == 2.weeks
    end

    it "should set a browser cookie indicating 'Remember Me' is working" do
      post :create, :user => { :email => "test@test.com",
                               :password => "test",
                               :remember_me => "1" },
                    :registered => "yes"

      expire_time_from_cookie_string(response, 'user_credentials').should be_close(Time.now + 2.weeks, 2)
    end

    private

    def expire_time_from_cookie_string(current_response, cookie_name)
      relevant_cookie = current_response.headers['Set-Cookie'].grep(/^#{cookie_name}/).first
      parts_list      = relevant_cookie.split('; ')
      expires         = parts_list.grep(/^expires/).first
      date_string     = expires.split('=').last
      Time.parse(date_string)
    end
  end
end