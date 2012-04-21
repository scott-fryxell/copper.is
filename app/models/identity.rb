class Identity < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  has_many :royalty_checks, :through => :pages

  attr_accessible :provider, :uid, :username

  validates :provider, presence:true
  validate :presence_of_username_or_uid

  def presence_of_username_or_uid
    unless self.username or self.uid
      errors.add(:uid, "uid must exist")
      errors.add(:username, "username must exist")
    end
  end

  before_save do
    self.type = Identity.subclass_from_provider(self.provider).to_s unless self.type
  end

  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'].to_s)
  end

  def self.create_with_omniauth(auth)
    Identity.create(uid: auth['uid'].to_s, provider: auth['provider'])
  end

  def self.subclass_from_provider(provider)
    provider = 'google' if provider == 'google_oauth2'
    ("Identities::" + provider.to_s.capitalize).constantize
  end

  def self.factory(opts = {})
    Identity.subclass_from_provider(opts[:provider]).create(opts)
  end

  def self.provider_from_url(url)
    case URI.parse(url).host
    when /facebook\.com$/ then 'facebook'
    when /tumblr\.com$/ then 'tumblr'
    when /twitter\.com$/ then 'twitter'
    when /google\.com$/ then 'google'
    when /vimeo\.com$/ then 'vimeo'
    when /flickr\.com$/ then 'flickr'
    when /github\.com$/ then 'github'
    when /youtube\.com$/ then 'youtube'
    when /soundcloud\.com$/ then 'soundcloud'
    else
      nil
    end
  end
  def self.find_or_create_from_url(url)
    provider = provider_from_url(url)
    i = subclass_from_provider(provider).discover_uid_and_username_from_url url
    p "i: #{i}"
    ident = Identity.where('provider = ? and (uid = ? OR username = ?)',
                           provider,i[:uid],i[:username]).first
    puts "ident: #{ident}"
    unless ident
      ident = factory(provider:provider,username:i[:username],uid:i[:uid])
    end
    ident
  end

  def inform_non_user_of_promised_tips
    raise "not implemented in subclass" unless block_given?
    unless self.user_id
      yield
    end
  end

  def populate_uid_and_username!
    unless self.uid and self.username
      unless self.uid
        populate_uid_from_username!
      else
        populate_username_from_uid!
      end
    end
  end

  def populate_username_from_uid!
    raise "not implemented in subclass" unless block_given?
    yield
    save!
  end

  def populate_uid_from_username!
    raise "not implemented in subclass" unless block_given?
    yield
    save!
  end
end
