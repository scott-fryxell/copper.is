require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Notifier do
  fixtures :users, :roles_users
  include MailTestHelper

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = users(:active)
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
        @message.body.should =~ /The next step is to fund your tip fund so that you can begin rewarding your favorite creators./
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

  describe "user email change notification to existing address" do

    before(:each) do
      @user.new_email = "newemail@test.com"
      @user.save
      @message = Notifier.create_email_change_notify(@user)
    end

    it "should render successfully" do
      lambda {@message}.should_not raise_error
    end

    it "should be from the right address" do
      @message.from[0].should =~/service@weave.us/
    end

    it "should have the correct subject line" do
      @message.subject.should =~ /Your Weave email address has changed/
    end

    describe "body" do

      it "should contain a message indicating that a new email address has been attachd to the account" do
        @message.body.should =~ /You recently changed the email address for your Weave account./
      end

      it "should have a link for help if user did not make this request" do
        @message.body.should =~ /support\/compromised_account/
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

  describe "user email change confirmation to new address" do

    before(:each) do
      @user.new_email = "newemail@test.com"
      @user.new_email_token = Authlogic::Random.hex_token[0..100]
      @user.save
      @message = Notifier.create_email_change_confirm(@user)
    end

    it "should render successfully" do
      lambda {@message}.should_not raise_error
    end

    it "should be from the right address" do
      @message.from[0].should =~/service@weave.us/
    end

    it "should have the correct subject line" do
      @message.subject.should =~ /Confirm your new Weave email address/
    end

    describe "body" do

      it "should contain a message indicating that the new address is awaiting confirmation" do
        @message.body.should =~ /A request has been made to change the email address of your Weave account/
      end

      it "should have a link for the user to confirm the new email address" do
        @message.body.should =~ /confirm_new_email\/#{@user.new_email_token}/
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