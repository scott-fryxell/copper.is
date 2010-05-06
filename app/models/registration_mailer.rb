class RegistrationMailer < ActionMailer::Base
  def confirm(recipient)
    subject    'RegistrationMailer#confirm'
    recipients recipient
    from       'service@fasterlighterbetter.com'
    sent_on    Time.now
    
    body       :greeting => 'Hi,'
  end
end
