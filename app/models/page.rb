class Page < ActiveRecord::Base
  belongs_to :author
  has_many :tips
  has_many :checks, :through => :tips

  include Enqueueable
  include Historicle
  include Eventable
  include Itemable
  include State::Ownable
  include URL::Learnable

  scope :safe,         -> { where(nsfw:false) }
  scope :charged_tips, -> { joins(:tips).where('tips.paid_state=?', 'charged') }
  scope :recent,       -> { joins(:tips).select('pages.*, count("tips") as tip_count').group('pages.id').having('count("tips") > 1' ).order("pages.updated_at DESC") }
  scope :trending,     -> { joins(:tips).select('pages.*, count("tips") as tip_count').group('pages.id').having('count("tips") > 1' ).order('tip_count desc, pages.updated_at DESC') }

  def host
    URI.parse(url).host
  end

end
