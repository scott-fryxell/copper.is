class MailTestController < ApplicationController
  def create_confirmation
    # modify confirm in the model to take an email address to send itself to
    email = RegistrationMailer.deliver_confirm('spankysyourpal@gmail.com')
    render(:text => '<pre>' + email.encoded + '</pre>')
  end
end