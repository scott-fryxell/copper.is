module Message

  module Payable

    extend ActiveSupport::Concern

    def tell_about_payment
      # TODO: send rails 4 email
    end

    def ask_for_bank_info
      # TODO: send rails 4 email
    end

  end

end
