module Enqueueable

  extend ActiveSupport::Concern

  included do
    @queue = :high
  end

  module ClassMethods
    def perform(obj_id, message, args=[])
      find(obj_id).send(message, *args)
    end
  end

end
