module Payable
  extend ActiveSupport::Concern

  included do

    scope :promised,   -> { where(paid_state:'promised') }
    scope :charged,    -> { where(paid_state:'charged') }
    scope :kinged,     -> { where(paid_state:'kinged').readonly }
    scope :for_author, -> { where(paid_state:['kinged','charged']).readonly }


    state_machine :paid_state, :initial => :promised do
      event :pay do
        transition :promised => :charged
      end

      event :claim do
        transition :charged => :kinged
      end

      state :charged, :kinged do
        validate :validate_presence_of_paid_order
      end

      state :kinged do
        validate :validate_presence_of_check
      end
    end

  end

end
