class Identity < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  has_many :tips, :through => :pages
  has_many :royalty_checks, :through => :pages

  attr_accessible :provider, :uid, :username

  validates :provider, presence:true
  validate :presence_of_username_or_uid
  
  scope :strangers, where('identity_state = ?', 'stranger')
  scope :wanted, where('identity_state = ?', 'wanted')
  scope :known, where('identity_state = ?', 'known')

  state_machine :identity_state, initial: :stranger do
    event :publicize do
      transition :stranger => :wanted
    end
    event :join do
      transition :stranger => :known, :if => proc{|ident| ident.user_id}
      transition :wanted => :known, :if => proc{|ident| ident.user_id}
    end
  end
  
  @queue = :high
  def self.perform(page_id, message, args=[])
    find(page_id).send(message, *args)
  end

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
    ident = Identity.where('provider = ? and (uid = ? OR username = ?)',
                           provider,i[:uid],i[:username]).first
    unless ident
      ident = factory(provider:provider,username:i[:username],uid:i[:uid])
    end
    ident
  end
  
  def message_wanted!
    raise "this identity has a user" if self.user_id
    raise "must be implemented in child class" unless block_given?
    if self.message.nil?
      yield
      self.message = Time.now
      save!
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
  
  # def try_to_create_royalty_check!
  #   if self.tips.charged.count > 0
  #     royalty_check = RoyaltyCheck.new
  #     royalty_check.tips = self.tips.charged.all
  #     royalty_check.tips.each do |tip|
  #       tip.king_me!
  #     end
  #     royalty_check.save!
  #     royalty_check
  #   else
  #     nil
  #   end
  # end
  
  def try_to_add_to_wanted_list!
    if self.tips.charged.sum(:amount_in_cents) > 100
      self.publicize!
    end
  end
end
