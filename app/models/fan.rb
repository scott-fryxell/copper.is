class Fan < ActiveRecord::Base
  has_paper_trail
  has_many :orders
  
  def tip!(amount_in_cents, url, title = nil)
    current_order.tips.create!(url:url,amount_in_cents:amount_in_cents,title:title)
  end
  
  def current_order
    orders.current.first or orders.create!
  end
end
