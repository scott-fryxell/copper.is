class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips

  validates :url, :format => {:with => URI::regexp, :message => 'not a valid URL'}

  attr_accessible :title
  
  before_save :normalize
  
  def normalize
    self.url = Addressable::URI.parse(self.url).normalize.to_s
  end
end
