module Enqueueable
  def self.included(base)
    def base.perform(page_id, message, args=[])
      find(page_id).send(message, *args)
    end
    base.instance_eval do
      @queue = :high
    end
  end
end
