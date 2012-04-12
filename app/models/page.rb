class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips

  validates :url,
    :format => {:with => URI::regexp, :message => 'not a valid URL'},
    :presence => true

  attr_accessible :title, :url

  before_save :normalize
  
  scope :authored, where("identity_id IS NOT NULL")
  scope :unauthored, where("identity_id IS NULL")
  
  def normalize
    self.url = Addressable::URI.parse(self.url).normalize.to_s
  end
  
  def self.normalized_find_by_url(url)
  end
  
  def self.normalized_find_or_create_by_url(url)
  end
end
