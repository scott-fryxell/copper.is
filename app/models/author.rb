class Author < ActiveRecord::Base
  has_many :checks
  has_many :pages
  has_many :channels
  
  belongs_to :user
  
  attr_accessible :city
  
  validate :at_least_one_channel?, :on => :update
  
  def merge!(rhs)
    self.checks += rhs.checks
    save!
    rhs.destroy
    self
  end
  
  def primary_channel
    channels.first
  end
  
  def at_least_one_channel?
    channels.count > 0
  end
  
  def try_to_create_check!
    the_tips = []
    self.identities.each do |ident|
      the_tips += ident.tips.charged.all
    end
    unless the_tips.empty?
      if check = self.checks.create
        the_tips.each do |tip|
          check.tips << tip
          tip.claim!
          tip.save!
        end
        check.save!
      end
    end
  end
end
