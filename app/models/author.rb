class Author < ActiveRecord::Base

  belongs_to :user, touch:true
  has_many :pages
  has_many :tips, :through => :pages
  has_many :checks, :through => :pages

  include Enqueueable
  include Historicle
  include URL::Authorizable
  include URL::Knowable

  validates :username, uniqueness:{scope:'provider'}, allow_blank:true
  validates :uid, uniqueness:{scope:'provider'}, allow_blank:true
  validates :provider, presence:true
  validate  :validate_presence_of_username_or_uid

  scope :pending_royalties, -> { joins(:tips).where("tips.paid_state='charged'").group('authors.id').select("authors.*, count('tips') as charged_tips_count").order('charged_tips_count desc') }


  def self.parse_url url
    # TODO: extend URL::parse to do this for us
    unless url.respond_to?(:path)
      url = URI.parse(url)
    end

    url

  end

  def validate_presence_of_username_or_uid
    unless self.username or self.uid
      errors.add(:uid, "uid must exist")
      errors.add(:username, "username must exist")
    end
  end

  def validate_user_id_is_nil
    if self.user_id
      errors.add(:user_id, "user_id must be nil")
    end
  end

  def url
    if username
      "https://#{self.provider}.com/#{self.username}"
    else
      "https://#{self.provider}.com/#{self.uid}"
    end
  end

  def determine_image
    return "/assets/icons/silhouette.svg" unless block_given?
    yield
  end

end
