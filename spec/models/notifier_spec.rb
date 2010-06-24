require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Notifier do
  fixtures :roles_users, :users
  include MailTestHelper

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = users(:email1)
  end

  describe "password reset message" do

    before(:each) do
      @message = Notifier.create_password_reset(@user)
    end

    it "should render successfully" do
      lambda { @message }.should_not raise_error
    end

    it "should be from the right address" do
      @message.from[0].should =~/service@weave.us/
    end

    it "should have the correct subject line" do
      @message.subject.should =~ /Weave account password reset instructions/
    end

    describe "body" do

      it "should contain the user's email address" do
        @message.body.should =~ /test@test.com/
      end

      it "should have a link with perishable token to reset your password" do
        @message.body.should =~ /password\/reset\/#{@user.perishable_token}/
      end

      it "should have the text 'A request has been made to reset the Weave account password'" do
        @message.body.should =~ /A request has been made to reset the Weave account password for/
      end

    end

    it "should deliver successfully" do
      lambda { Notifier.deliver(@message) }.should_not raise_error
    end

    it "should deliver one message" do
      Notifier.deliver(@message)
      ActionMailer::Base.deliveries.length.should == 1
    end

  end

  describe "user activation message" do

    before(:each) do
      @message = Notifier.create_user_activation(@user)
    end

    it "should render successfully" do
      lambda {@message}.should_not raise_error
    end

    it "should be from the right address" do
      @message.from[0].should =~/service@weave.us/
    end

    it "should have the correct subject line" do
      @message.subject.should =~ /Weave account activation instructions/
    end

    describe "body" do

      it "should contain a welcome message" do
        @message.body.should =~ /Thank you for creating a Weave account! Click the url below to activate your account!/
      end

      it "should have a link with perishable token to activate your account" do
        @message.body.should =~ /activate\/#{@user.perishable_token}/
      end
    end

    it "should deliver successfully" do
      lambda {Notifier.deliver(@message)}.should_not raise_error
    end

    it "should deliver one message" do
      Notifier.deliver(@message)
      ActionMailer::Base.deliveries.length.should == 1
    end

  end

  describe "user welcome message" do

    before(:each) do
      @message = Notifier.create_user_welcome(@user)
    end

    it "should render successfully" do
      lambda {@message}.should_not raise_error
    end

    it "should be from the right address" do
      @message.from[0].should =~/service@weave.us/
    end

    it "should have the correct subject line" do
      @message.subject.should =~ /Welcome to Weave/
    end

    describe "body" do

      it "should contain a welcome message" do
        @message.body.should =~ /Welcome to Weave!/
      end

      it "should contain a link to Weave" do
        @message.body.should =~ /http:\/\/0.0.0.0:3000\//
      end

      it "should contain additional copy" do
        @message.body.should =~ /The next step is to fund your tip stash so that you can begin rewarding your favorite creators./
      end

    end

    it "should deliver successfully" do
      lambda {Notifier.deliver(@message)}.should_not raise_error
    end

    it "should deliver one message" do
      Notifier.deliver(@message)
      ActionMailer::Base.deliveries.length.should == 1
    end

  end

end