class Page < ActiveRecord::Base
  include Enqueueable
  
  belongs_to :identity
  has_many :tips
  has_many :royalty_checks, :through => :tips

  attr_accessible :title, :url

  validates :url, :presence => true
  
  validate :url_points_to_real_site
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end
  
  [:orphaned, :spiderable, :manual, :fostered, :adopted].each do |state|
    scope state, where("author_state = ?", state)
  end

  state_machine :author_state, initial: :orphaned do
    event :adopt do
      transition any => :adopted
    end
    
    event :reject do
      transition :orphaned   => :spiderable,
                 :spiderable => :manual,
                 :manual     => :fostered,
                 :fostered   => :fostered
    end
    
    after_transition any => :orphaned do |page,transition|
      Resque.enqueue Page, page.id, :discover_identity!
    end
    
    after_transition any => :spiderable do |page,transition|
      Resque.enqueue Page, page.id, :find_identity_from_author_link!
    end
    
    after_transition any => :manual do |page,transition|
      Rails.logger.warn "Page set to :manual, id: #{page.id}"
    end
    
    after_transition any => :fostered do |page,transition|
      Rails.logger.warn "Page set to :fostered, id: #{page.id}"
    end
  end

  def discover_identity!
    if Identity.provider_from_url(self.url) and
        self.identity = Identity.find_or_create_from_url(self.url)
      adopt!
    else
      reject!
    end
  end

  def find_identity_from_author_link!
    if author_tag    = Nokogiri::HTML(open(self.url)).css('link[rel=author]') and
       author_link   = author_tag.attr('href').value                          and
       self.identity = Identity.find_or_create_from_url(author_link)
      adopt!
    else
      reject!
    end
  end
end
