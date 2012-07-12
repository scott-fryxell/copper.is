class Author < ActiveRecord::Base
  has_many :checks
  has_many :pages
  has_many :channels, :through => :pages
  
  belongs_to :user
  
  attr_accessible :city
  
  validate :at_least_one_channel?, :on => :update
  
  def merge!(rhs)
    self.checks += rhs.checks
    save!
    # rhs.destroy
    self
  end
  
  def primary_channel
    channels.first
  end
  
  def at_least_one_channel?
    self.channels.count > 0
  end
end
