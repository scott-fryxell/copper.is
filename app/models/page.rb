class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips

  validates :url,
    # :format => {:with => URI::regexp, :message => 'not a valid URL'},
    :presence => true

  attr_accessible :title, :url

  validate :url_points_to_real_site
  
  before_save :normalize
  
  scope :authored, where("identity_id IS NOT NULL")
  scope :unauthored, where("identity_id IS NULL")
  
  state_machine :author_state, initial: :orphaned do
    event :catorgorize do
      transition :orphaned => :providerable
    end
    event :found do
      transition [:manual,:providerable] => :adopted, :if => lambda{|page| page.identity_id.nil?}
      transition :spiderable => :providerable
    end
    event :discover do
      transition :orphaned => :spiderable
    end
    event :lost do
      transition :manual => :fostered
    end
  end
  
  def self.normalize(url)
    url.clone.
     sub(/^https?:\/\//,'').
     sub(/^www\./,'').
     sub(/\/$/,'')
  end
  
  def self.normalized_find(url)
    Page.find_by_url(Page.normalize(url))
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
  
  def discover_provider_user!
    raise 'TBD'
    save!
  end
  
  def find_provider_from_author_link!
    raise 'TBD'
    save!
  end
  
  def url_matches_provider?
    case URI.parse(self.original_url).host
    when /facebook.com$/ then true
    when /tumblr.com$/ then true
    when /twitter.com$/ then true
    when /google.com$/ then true
    when /vimeo.com$/ then true
    when /flickr.com$/ then true
    when /github.com$/ then true
    when /youtube.com$/ then true
    when /soundcloud.com$/ then true
    else
      false
    end
  end

  def normalize
    self.original_url = self.url
    self.url = Page.normalize(self.url)
    # self.url = Addressable::URI.parse(self.url).normalize.to_s
  end
  
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end
end
