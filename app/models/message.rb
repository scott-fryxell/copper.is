class Message < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  belongs_to :channel
  has_one :author, :through => :channel
  
  after_create do |message|
    Resque.enqueue Message, message.id, :post
  end

  def post
    channel.post(self.id)
  end
end
