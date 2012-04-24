class RoyaltyCheckMailer < ActionMailer::Base
  default :from => "orders@copper.is"
  helper :Layout
  
  def check(royalty_check)
    @royalty_check = royalty_check
    mail(:to => royalty_check.user.email, :subject => "Copper owes you cash")
  end
  
end
