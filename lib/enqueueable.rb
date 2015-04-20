module Enqueueable
  def self.included(base)
    def base.perform(obj_id, message, args=[])
      find(obj_id).send(message, *args)
    end
    base.instance_eval do
      @queue = :high
    end
  end
end
