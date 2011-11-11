class OrderMailer < ActionMailer::Base
  default :from => "orders@dirtywhitecouch.com"
  helper :Layout

  def reciept(order)
    @order = order
    mail(:to => order.fan.email, :subject => "DWC has processed your tips " + order.fan.name, :bcc => "orders@dirtywhitecouch.com")
  end
end
