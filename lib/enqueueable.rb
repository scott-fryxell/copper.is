module Enqueueable
  def self.included(base)
    def base.perform(obj_id, message, args=[])
      # puts message
      find(obj_id).send(message, *args)
    end
    base.instance_eval do
      @queue = :normal
    end
  end
end
