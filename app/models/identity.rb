class Identity < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  
  belongs_to :user
  has_many :pages
  has_many :tips, :through => :pages
  has_many :checks, :through => :pages

  attr_accessible :provider, :uid, :username

  # validates :username, uniqueness:{scope:'provider'}, allow_blank:true
  # validates :uid, uniqueness:{scope:'provider'}, allow_blank:true
  
  validates :provider, presence:true
  
  validate :validate_presence_of_username_or_uid
  def validate_presence_of_username_or_uid
    unless self.username or self.uid
      errors.add(:uid, "uid must exist")
      errors.add(:username, "username must exist")
    end
  end
  
  scope :stranger, where('identity_state = ?', 'stranger')
  scope :wanted, where('identity_state = ?', 'wanted')
  scope :known, where('identity_state = ?', 'known')

  state_machine :identity_state, initial: :stranger do
    event :publicize do
      transition :stranger => :wanted
    end
    
    event :join do
      transition any => :known
    end

    #end relationship with user
    event :remove_user do
      transition any => :stranger
    end

    state :stranger, :wanted do
      validate :validate_user_id_is_nil
    end

    state :wanted do
      def send_wanted_message
        raise "this identity has a user" if self.user_id
        _send_wanted_message
        self.message = Time.now
        save!
      end
    end
    
    state :known do
      validates :user_id, presence:true
    end
    
    after_transition any => :wanted do |author,transition|
      Resque.enqueue author.class, author.id, :send_wanted_message
    end
  end

  def validate_user_id_is_nil
    if self.user_id
      errors.add(:user_id, "user_id must be nil")
    end
  end

  after_save do
    if self.wanted? and !self.message
      Resque.enqueue self.class, self.id, :send_wanted_message
    end
  end
  
  before_save do

    if self.stranger?
      self.user = nil
    end

    self.type = Identity.subclass_from_provider(self.provider).to_s unless self.type
  end

  # --------------------------------------------------------------------
  
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
    when /example\.com$/ then 'phony'
    else
      nil
    end
  end
  
  def self.find_or_create_from_url(url)
    provider = provider_from_url(url)
    i = subclass_from_provider(provider).discover_uid_and_username_from_url url
    ident = Identity.where('provider = ? and (uid = ? OR username = ?)',
                           provider,i[:uid],i[:username]).first
    unless ident
      ident = factory(provider:provider,username:i[:username],uid:i[:uid])
    end
    ident
  end
  
  # --------------------------------------------------------------------
  
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
  
  def try_to_make_wanted!
    self.publicize! if self.tips.charged.count > 0
  end
end
