class Author < ActiveRecord::Base
  has_many :checks
  has_many :pages
  belongs_to :user
  
  attr_accessible :city
  
  def merge!(rhs)
    self.checks += rhs.checks
    save!
    rhs.destroy
    self
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
