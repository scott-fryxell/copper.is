class CheckMailer < ActionMailer::Base
  default :from => "orders@copper.is"
  helper :Layout
  
  def check(check)
    @check = check
    mail(:to => check.user.email, :subject => "Copper owes you cash")
  end
  
end
