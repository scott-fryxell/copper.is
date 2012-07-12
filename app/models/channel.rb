class Channel < ActiveRecord::Base
  has_paper_trail
  belongs_to :page
  has_many :messages
  has_one :author, :through => :page
  
  attr_accessible :site, :user, :type
  
  def you_have_tips_waiting!(check_id)
    messages.create! subject:     'you_have_tips_waiting',
                     slug:        generate_slug(),
                     redirect_to: "/checks/#{check_id}"
  end
  
  def post(message_id)
    send(message.subject,message_id)
  end
  
  def self.auth
    false
  end
end
