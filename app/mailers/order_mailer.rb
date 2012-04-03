class OrderMailer < ActionMailer::Base
  default :from => "orders@copper.is"
  helper :Layout
  
  def reciept(order)
    @order = order
    mail(:to => order.fan.email, :subject => "Copper has processed your tips " + order.fan.name)
  end
  
  def card_declinded(order)
    @order = order
    mail(:to => order.fan.email, :subject => "Copper has processed your tips " + order.fan.name)
  end
  
  def processing_error(order)
    @order = order
    mail(:to => order.fan.email, :subject => "Copper has processed your tips " + order.fan.name)
  end
end
