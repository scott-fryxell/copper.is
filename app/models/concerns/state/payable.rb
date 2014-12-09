module State
  module Payable
    extend ActiveSupport::Concern

    included do

      validates :order, presence:true
      validate :validate_only_being_added_to_current_order, :on => :create

      before_destroy do |tip|
        tip.page.touch
        raise CantDestroyException unless tip.promised?
      end

      scope :promised, -> { where(paid_state:'promised') }
      scope :paid,     -> { where(paid_state:'paid') }
      scope :given,    -> { where(paid_state:'given').readonly }
      scope :genuine,  -> { where(paid_state:['paid','given']).readonly }

      state_machine :paid_state, :initial => :promised do

        event :pay do
          transition :promised => :paid
        end

        event :claim do
          transition :paid => :given
        end

        state :paid, :given do
          validate :validate_presence_of_paid_order
        end

        state :given do
          validate :validate_presence_of_check
        end

      end

    end

    def validate_only_being_added_to_current_order
      unless self.order.current?
        errors.add(:order_id,"can only add a tip to a current order")
      end
    end

    def validate_presence_of_paid_order
      unless self.order.paid?
        errors.add(:order_id, "tip order must be :paid for :charged tips")
      end
    end

    def validate_presence_of_check
      unless self.check_id
        errors.add(:check_id, "check_id must not be null for :kinged tips")
      end
    end

  end

end
