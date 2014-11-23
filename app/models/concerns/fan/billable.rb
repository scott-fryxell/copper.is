module Fan

  module Billable

    extend ActiveSupport::Concern

    def send_paid_order_message card_number
      # TODO: send rails 4 email
    end

    def send_card_expired_message
      # TODO: send rails 4 email
    end

  end

end
