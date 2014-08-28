class Author < ActiveRecord::Base
  include Enqueueable
  include Historicle
  include URL::Authorizable
  include URL::Knowable

  belongs_to :user, touch:true
  has_many :pages
  has_many :tips, :through => :pages
  has_many :checks, :through => :pages

  validates :username, uniqueness:{scope:'provider'}, allow_blank:true
  validates :uid, uniqueness:{scope:'provider'}, allow_blank:true
  validates :provider, presence:true
  validate  :validate_presence_of_username_or_uid

  def validate_presence_of_username_or_uid
    unless self.username or self.uid
      errors.add(:uid, "uid must exist")
      errors.add(:username, "username must exist")
    end
  end

  def url
    if self.username
      "https://#{self.provider}.com/#{self.username}"
    else
      "https://#{self.provider}.com/#{self.uid}"
    end
  end

  scope :pending_royalties, -> { joins(:tips).where("tips.paid_state='charged'").group('authors.id').select("authors.*, count('tips') as charged_tips_count").order('charged_tips_count desc') }

  def validate_user_id_is_nil
    if self.user_id
      errors.add(:user_id, "user_id must be nil")
    end
  end

  def self.factory(opts = {})
    self.subclass_by_authorizer(opts[:provider]).create(opts)
  end

  def self.find_or_create_from_url(url)
    if provider = self.authorizer_from_url(url)
      i = self.subclass_by_authorizer(provider).discover_uid_and_username_from_url url
      ident = self.where('provider = ? and (uid = ? OR username = ?)', provider,i[:uid].to_s,i[:username]).first
      unless ident
        ident = factory(provider:provider,username:i[:username],uid:i[:uid])
      end
      ident
    else
      nil
    end
  end

  def populate_uid_and_username!
    if self.uid.blank? and self.username.blank?
      raise "both uid and username can't be blank"
    else
      if self.uid.blank?
        populate_uid_from_username!
      else
        populate_username_from_uid!
      end
    end
  end

  def populate_username_from_uid!
    raise "not implemented in subclass" unless block_given?
    raise "uid is blank" if self.uid.blank?
    yield
    save!
  end

  def populate_uid_from_username!
    raise "not implemented in subclass" unless block_given?
    raise "username is blank" if self.username.blank?
    yield
    save!
  end

  def profile_image
    return "/assets/icons/silhouette.svg" unless block_given?
    yield
  end
end
