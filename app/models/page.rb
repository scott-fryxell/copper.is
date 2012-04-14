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
  
  def normalize
    self.original_url = self.url
    self.url = Page.normalize(self.url)
    # self.url = Addressable::URI.parse(self.url).normalize.to_s
  end
  
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end
end
