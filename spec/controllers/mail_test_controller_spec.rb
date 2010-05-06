require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MailTestController do
  describe "when sending messages" do
    include MailTestHelper

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []

      @email = RegistrationMailer.create_confirm('test@test.com')
    end

    it "should have the correct recipient address" do
      @email.header['to'].to_s.should == 'test@test.com'
    end

    it "should be coming from the Faster Lighter Better service" do
      @email.header['from'].to_s.should == 'service@fasterlighterbetter.com'
    end

    it "should be sent within the last minute" do
      time_diff = Time.now - @email.header['date'].date
      time_diff.should be_close(0, 60)
    end

    it "should format the message correctly" do
      @email.body.should == load_mail_fixture('registration_mailer/confirm')
    end
    
    it "should have the correct subject line" do
      @email.header['subject'].to_s.should == 'RegistrationMailer#confirm'
    end

    it "should actually deliver the email" do
      ActionMailer::Base.deliveries.size.should == 0
      mail = RegistrationMailer.deliver(@email)
      ActionMailer::Base.deliveries.size.should == 1
      mail.body.should =~ /Find me in app/
    end
  end
end