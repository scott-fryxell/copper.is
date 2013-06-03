class Author < ActiveRecord::Base
  include Enqueueable
  has_paper_trail 
  belongs_to :user, touch:true
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

  def url
    if self.username
      "#{self.provider}.com/#{self.username}"
    else
      "#{self.provider}.com/#{self.uid}"
    end
  end
  
  scope :stranger, where(identity_state:'stranger')
  scope :wanted, where(identity_state:'wanted')
  scope :known, where(identity_state:'known')

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
      def ask_author_to_join
        raise "this author has a user" if self.user_id
        unless self.message

          send_wanted_message
          self.message = Time.now
          save!
        end
      end
    end
    
    state :known do
      validates :user_id, presence:true

      def create_page_for_author
        unless page = Page.where(url:self.url).first
          page = Page.create(url:self.url,title:self.username, author_state:'adopted')
        end
        page.author = self
        if self.user
          self.user.touch
        end
      end
    end
    
    after_transition any => :wanted do |author,transition|
      Resque.enqueue author.class, author.id, :ask_author_to_join
    end
    after_transition any => :known do |author,transition|
      Resque.enqueue Author, author.id, :create_page_for_author  
    end
  end

  def validate_user_id_is_nil
    if self.user_id
      errors.add(:user_id, "user_id must be nil")
    end
  end

  # after_save do
  #   if self.wanted? and !self.message
  #     Resque.enqueue self.class, self.id, :ask_author_to_join
  #   end
  # end
  
  before_save do
    if self.stranger?
      self.user = nil
    end

    self.type = Author.subclass_from_provider(self.provider).to_s unless self.type
  end


  # --------------------------------------------------------------------
  
  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'].to_s)
  end

  def self.create_with_omniauth(auth)
    Author.create(uid: auth['uid'].to_s, provider: auth['provider'])
  end

  def self.subclass_from_provider(provider)
    provider = 'google' if provider == 'google_oauth2'
    ("Authors::" + provider.to_s.capitalize).constantize
  end

  def self.factory(opts = {})
    Author.subclass_from_provider(opts[:provider]).create(opts)
  end

  def self.provider_from_url(url)
    begin  
      uri = URI.parse(url)
      return nil unless /tumblr\.com$/.match(uri.host) or uri.path.size > 1 or uri.query or uri.fragment
    rescue => e
      return nil
    end

    case uri.host
    when /facebook\.com$/ then 
      if %r{/sharer|/home|/login|/status/|/search|/dialog/|/signup|r.php|/recover/|/mobile/|find-friends|badges|directory|appcenter|application}.match(uri.path)
        nil
      else
        'facebook'
      end
    when /tumblr\.com$/ then 
      if %r{www.tumblr.com}.match(uri.host) and uri.path.size < 3
        nil
      elsif  %r{/dashboard|/customize}.match(uri.path)
        nil
      else
        'tumblr'
      end
    when /twitter\.com$/ then
      if %r{/login|/share}.match(uri.path)
        nil
      elsif %r{2012.twitter.com|business.twitter.com}.match(uri.host)
        nil
      else
        'twitter'
      end
    when /plus\.google\.com$/ then 'google'
    when /vimeo\.com$/ then 
      if %r{/groups/}.match(uri.path)
        nil
      else
        'vimeo'
      end
    when /flickr\.com$/ then 'flickr'
    when /github\.com$/ then 
      if %r{gist.github.com}.match(uri.host)
        nil
      elsif %r{/blog}.match(uri.path)
        nil
      else
        'github'
      end
    when /youtube\.com$/ then 'youtube'
    when /soundcloud\.com$/ then 
      if  %r{/dashboard}.match(uri.path)
        nil
      else
        'soundcloud'
      end
    when /example\.com$/ then 'phony'
    else
      nil
    end
  rescue URI::InvalidURIError => e
    return nil
  end
  
  def self.find_or_create_from_url(url)
    if provider = provider_from_url(url)
      i = subclass_from_provider(provider).discover_uid_and_username_from_url url
      ident = Author.where('provider = ? and (uid = ? OR username = ?)', provider,i[:uid],i[:username]).first
      unless ident
        ident = factory(provider:provider,username:i[:username],uid:i[:uid])
      end
      ident
    else
      nil
    end
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
