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
  
  [:orphaned, :providerable, :spiderable, :manual, :fostered, :adopted].each do |state|
    scope state, where("author_state = ?", state)
  end

  state_machine :author_state, initial: :orphaned do
    event :catorgorize do
      transition any => :providerable
    end
    
    event :adopt do
      transition any => :adopted
    end
    
    event :lose do
      transition :manual       => :fostered,
                 :providerable => :spiderable,
                 :spiderable   => :manual,
                 :orphaned     => :spiderable,
                 :adopted      => :orphaned,
                 :fostered     => :fostered
    end
    
    after_transition any => :orphaned do |page,transition|
      Resque.enqueue Page, page.id, :match_url_to_provider!
    end
    
    after_transition any => :providerable do |page,transition|
      Resque.enqueue Page, page.id, :discover_identity!
    end
    
    after_transition any => :spiderable do |page,transition|
      Resque.enqueue Page, page.id, :find_identity_from_author_link!
    end
  end

  def match_url_to_provider!
    if Identity.provider_from_url(self.url)
      self.catorgorize!
    else
      self.lose!
    end
  end

  def discover_identity!
    if self.identity = Identity.find_or_create_from_url(self.url)
      save!
      self.adopt!
    else
      self.lose!
    end
  end

  def find_identity_from_author_link!
    if author_tag = Nokogiri::HTML(open(self.url)).css('link[rel=author]')
      if author_link = author_tag.attr('href').value
        if self.identity = Identity.find_or_create_from_url(author_link)
          self.adopt!
          save!
        else
          self.lose!
        end
      else
        self.lose!
      end
    end
  end
end
