class Author < ActiveRecord::Base
  has_paper_trail
  has_many :pages
  has_many :identities
  has_many :channels, :through => :pages
  has_many :tips, :through => :pages
  has_many :checks
  has_one  :fan

  def merge!(rhs)
    self.identities += rhs.identities
    self.pages += rhs.pages
    save!
    # rhs.destroy
    self
  end
  
  def primary_channel
    channels.first
  end
  
  def you_have_tips_waiting!
    primary_channel.you_have_tips_waiting!
  end
  
  def ready_for_check_ids
    tips.paid.select(:id).map(&:id)
  end
  
  def create_a_check!
    Tip.transaction do
      check = checks.create!
      check.tips = Tip.find(ready_for_check_ids)
      check.save!
      check.tips.each do |tip|
        tip.king!
        tip.save!
      end
    end
  end
end
