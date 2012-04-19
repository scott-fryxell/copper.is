class OrderMailer < ActionMailer::Base
  default :from => "orders@copper.is"
  helper :Layout
  
  def reciept(order)
    @order = order
    mail(:to => order.user.email, :subject => "Copper has processed your tips " + order.user.name)
  end
  
end
