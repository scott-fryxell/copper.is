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

  def discover_provider_user!
    provider, uid = case URI.parse(self.url).host
                    when /facebook\.com$/ then discover_facebook_uid
                    when /tumblr\.com$/ then discover_tumblr_uid
                    when /twitter\.com$/ then discover_twitter_uid
                    when /google\.com$/ then discover_google_uid
                    when /vimeo\.com$/ then discover_vimeo_uid
                    when /flickr\.com$/ then discover_flickr_uid
                    when /github\.com$/ then discover_github_uid
                    when /youtube\.com$/ then discover_youtube_uid
                    when /soundcloud\.com$/ then discover_soundcloud_uid
                    else
                      self.lost()
                    end
    if provider and uid
      if ident = Identity.where('uid = ?', uid).first
        self.identity = ident
      else
        self.identity = Identity.factory(provider:provider,uid:uid)
      end
      save! # THINK: is this nessecary?
      self.found!
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

  def discover_facebook_uid
    if self.url =~ /set=/
      ['facebook', self.url.split("set=").last.split("&").first.split('.').last]

    elsif self.url =~ /\/events\//
      doc = Nokogiri::HTML(open(self.url))
      [
       'facebook',
        doc.to_s.split('Report').first.split('rid=').last.split('&amp').first
       ]
    else
      logger.info "reaching out to: #{self.url}"
      doc = Nokogiri::HTML(open(self.url))
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

    if self.url =~ /\/status\//
      screen_name = URI.parse(self.url).fragment.split('!/').last.split('/').first
    else
      screen_name = URI.parse(self.url).fragment.split('!/').last
    end

    ['twitter',Twitter.user(screen_name).id]

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
    if self.url =~ /\/user\//
      [
       'youtube',
        URI.parse(self.url).path.split('/').last
       ]
    else
      @client ||= YouTubeIt::Client.new(:dev_key => Copper::Application.config.google_code_dev_key)
      video_id = URI.parse(self.url).query.split('&').find{|e| e =~ /^v/}.split('=').last
      [
       'youtube',
        @client.video_by(video_id).author.name
       ]
    end
  end

  def discover_soundcloud_uid
    raise 'TBD'
  end
end
