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
      transition [:manual,:providerable] => :adopted, :if => lambda{|page| page.identity_id.nil?}
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
    provider, uid = case URI.parse(self.original_url).host
                    when /facebook.com$/ then discover_facebook_uid
                    when /tumblr.com$/ then discover_tumblr_uid
                    when /twitter.com$/ then discover_twitter_uid
                    when /google.com$/ then discover_google_uid
                    when /vimeo.com$/ then discover_vimeo_uid
                    when /flickr.com$/ then discover_flickr_uid
                    when /github.com$/ then discover_github_uid
                    when /youtube.com$/ then discover_youtube_uid
                    when /soundcloud.com$/ then discover_soundcloud_uid
                    else
                      self.lost()
                    end
    if ident = Identity.where('uid = ?', uid).first
      self.identity = ident
    else
      self.identity = Identity.create(provider:provider,uid:uid)
    end
  end

  def find_provider_from_author_link!
    raise 'TBD'
    save!
  end

  def url_matches_provider?
    case URI.parse(self.original_url).host
    when /facebook.com$/ then true
    when /tumblr.com$/ then false
    when /twitter.com$/ then false
    when /google.com$/ then false
    when /vimeo.com$/ then false
    when /flickr.com$/ then false
    when /github.com$/ then false
    when /youtube.com$/ then false
    when /soundcloud.com$/ then false
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

  def discover_facebook_uid
    if self.original_url =~ /set=/
      ['facebook', self.original_url.split("set=").last.split("&").first.split('.').last]
    elsif self.original_url =~ /\/events\//
      doc = Nokogiri::HTML(open(self.original_url))
      [
       'facebook',
        doc.to_s.split('Report').first.split('rid=').last.split('&amp').first
       ]
    else
      doc = Nokogiri::HTML(open(self.original_url))
      [
       'facebook',
       JSON.parse(doc.css('#pagelet_timeline_main_column').attr('data-gt').content)['profile_owner']
      ]
    end
  end

  def discover_tumblr_uid
    raise 'TBD'
  end

  def discover_twitter_uid
    raise 'TBD'
  end

  def discover_google_uid
    raise 'TBD'
  end

  def discover_vimeo_uid
    raise 'TBD'
  end

  def discover_flickr_uid
    raise 'TBD'
  end

  def discover_github_uid
    raise 'TBD'
  end

  def discover_youtube_uid
    raise 'TBD'
  end

  def discover_soundcloud_uid
    raise 'TBD'
  end
end
