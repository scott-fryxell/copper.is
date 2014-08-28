class Page < ActiveRecord::Base
  include Enqueueable
  include Itemable
  include Historicle
  include URL::Learnable
  include URL::Ownable


  belongs_to :author
  has_many :tips
  has_many :checks, :through => :tips

  attr_accessor :nested

  scope :safe,         -> { where(nsfw:false) }
  scope :charged_tips, -> { joins(:tips).where('tips.paid_state=?', 'charged') }
  scope :recent,       -> { joins(:tips).select('pages.*, count("tips") as tip_count').group('pages.id').having('count("tips") > 1' ).order("pages.updated_at DESC") }
  scope :trending,     -> { joins(:tips).select('pages.*, count("tips") as tip_count').group('pages.id').having('count("tips") > 1' ).order('tip_count desc') }

  def self.adoption_rate
    (Float(Page.adopted.count)/Float(Page.all.count - Page.dead.count) * 100).round
  end

  def host
    URI.parse(url).host
  end

end
