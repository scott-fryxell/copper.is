class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips

  validates :url,
    # :format => {:with => URI::regexp, :message => 'not a valid URL'},
    :presence => true

  attr_accessible :title, :url

  validate :url_points_to_real_site

  before_save :normalize

  [:orphaned, :providerable, :spiderable, :manual, :fostered, :adopted].each do |state|
    scope state, where("author_state = ?", state)
  end

  state_machine :author_state, initial: :orphaned do
    event :catorgorize do
      transition :orphaned => :providerable
    end
    event :found do
      transition :manual => :adopted, :if => lambda{|page| page.identity_id}
      transition :providerable => :adopted, :if => lambda{|page| page.identity_id}
      transition :spiderable => :providerable
    end
    event :discover do
      transition :orphaned => :spiderable
    end
    event :lost do
      transition :manual => :fostered
      transition :providerable => :spiderable
    end
  end

  def self.normalize(uri)
    URI.parse(uri).host.sub(/^www\./,'') rescue nil
  end

  def self.normalized_find(url)
    Page.find_by_normalized_url(Page.normalize(url))
  end

  def self.normalized_find_or_create(url,title = nil)
    title ||= url
    normalized_find(url) or create(url:url,title:title)
  end

  def match_url_to_provider!
    if url_matches_provider?
      self.catorgorize
    else
      self.discover
    end
  end

  # trys to attach an identity and transition from :providerable to :adopted
  def discover_provider_user!
    provider, uid, username =
    case URI.parse(self.url).host
    when /facebook\.com$/
      ['facebook'] + Identities::Facebook.discover_uid_and_username_from_url(self.url)
    when /tumblr\.com$/
      ['tumblr'] + Identities::Tumblr.discover_uid_and_username_from_url(self.url)
    when /twitter\.com$/
      ['twitter'] + Identities::Twitter.discover_uid_and_username_from_url(self.url)
    when /google\.com$/
      ['google'] + Identities::Google.discover_uid_and_username_from_url(self.url)
    when /vimeo\.com$/
      ['vimeo'] + Identities::Vimeo.discover_uid_and_username_from_url(self.url)
    when /flickr\.com$/
      ['flickr'] + Identities::FLickr.discover_uid_and_username_from_url(self.url)
    when /github\.com$/
      ['github'] + Identities::Github.discover_uid_and_username_from_url(self.url)
    when /youtube\.com$/
      ['youtube'] + Identities::Youtube.discover_uid_and_username_from_url(self.url)
    when /soundcloud\.com$/
      ['soundcloud'] + Identities::Soundcloud.discover_uid_and_username_from_url(self.url)
    else
      self.lost()
    end
    
    if provider and ( uid or username )
      if ident = Identity.where('uid = ? OR username = ?', uid, username).first
        self.identity = ident
      else
        self.identity = Identity.factory(provider:provider,uid:uid,username:username)
      end
      save! # THINK: is this nessecary?
      self.found!
    else
      self.lost!
    end
  end

  def find_provider_from_author_link!
    raise 'TBD'
    save!
  end

  def url_matches_provider?
    case URI.parse(self.url).host
    when /facebook\.com$/ then true
    when /tumblr\.com$/ then false
    when /twitter\.com$/ then true
    when /google\.com$/ then false
    when /vimeo\.com$/ then false
    when /flickr\.com$/ then false
    when /github\.com$/ then false
    when /youtube\.com$/ then true
    when /soundcloud\.com$/ then false
    else
      nil
    end
  end

  def normalize
    self.normalized_url = Page.normalize(self.url)
    # self.url = Addressable::URI.parse(self.url).normalize.to_s
  end

  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

end
