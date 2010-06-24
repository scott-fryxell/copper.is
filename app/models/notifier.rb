class Notifier < ActionMailer::Base

  def password_reset(user)
    from          'service@weave.us'
    subject       'Weave account password reset instructions'
    recipients    user.email
    sent_on       Time.now
    content_type  'multipart/alternative'
    body          :user => user
  end

  def user_activation(user)
    from          'service@weave.us'
    subject       'Weave account activation instructions'
    recipients    user.email
    sent_on       Time.now
    content_type  'multipart/alternative'
    body          :user => user
  end

  def user_welcome(user)
    from          'service@weave.us'
    subject       'Welcome to Weave'
    recipients    user.email
    sent_on       Time.now
    content_type  'multipart/alternative'
    body
  end

end