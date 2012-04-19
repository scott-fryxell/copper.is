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
    if Identity.provider_from_url(self.url)
      self.catorgorize!
    else
      self.discover!
    end
  end

  def discover_provider_user!
    if self.identity = Identity.find_or_create_from_url(self.url)
      save!
      self.found!
    else
      self.lost!
    end
  end

  def find_provider_from_author_link!
    raise 'TBD'
    save!
  end

  def normalize
    self.normalized_url = Page.normalize(self.url)
    # self.url = Addressable::URI.parse(self.url).normalize.to_s
  end

  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

end
