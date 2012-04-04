# require 'resque_heroku_scaling_canary'

class TipOrderChargeJob
  @queue = :high
  
  # extend Resque::Plugins::ScalingCanary
  
  def self.perform( tip_order_id )
    order = TipOrder.find(tip_order_id)
    order.charge
    OrderMailer.reciept(order).deliver
  rescue Stripe::CardError => e
    OrderMailer.card_declined(order).deliver
  rescue Stripe::InvalidRequestError => e
    OrderMailer.processing_error(order).deliver
  end
  
  # def self.minimum_workers_needed
  #   Copper::Application.config.resque_high_min_workers || 2
  # end
end
