class Page < ActiveRecord::Base
  belongs_to :identity
  has_many :tips
  has_many :royalty_checks, :through => :tips

  attr_accessible :title, :url

  validate :url_points_to_real_site
  validates :url, :presence => true

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
      transition :spiderable => :adopted
    end
    event :discover do
      transition :orphaned => :spiderable
    end
    event :lost do
      transition :manual => :fostered
      transition :providerable => :spiderable
      transition :spiderable => :manual
    end
  end
  
  @queue = :high
  def self.perform(page_id, message, args=[])
    find(page_id).send(message, *args)
  end

  def match_url_to_provider!
    if Identity.provider_from_url(self.url)
      self.catorgorize!
    else
      self.discover!
    end
  end

  def discover_identity!
    if self.identity = Identity.find_or_create_from_url(self.url)
      save!
      self.found!
    else
      self.lost!
    end
  end

  def find_identity_from_author_link!
    author_link = Nokogiri::HTML(open(self.url)).css('link[rel=author]').attr('href').value rescue nil
    if author_link
      if self.identity = Identity.find_or_create_from_url(author_link)
        self.found!
        save!
      else
        self.lost!
      end
    else
      self.lost!
    end
  end

#  def normalize
#    self.normalized_url = Page.normalize(self.url)
#    # self.url = Addressable::URI.parse(self.url).normalize.to_s
#  end

  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

end
