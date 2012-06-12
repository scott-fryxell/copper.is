class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  
  belongs_to :author
  belongs_to :site
  has_many :tips
  has_many :checks, :through => :tips

  attr_accessible :url

  validates :url, :presence => true

  after_create do
    find_or_create_site!
    Resque.enqueue Page, id, :find_author!
  end
  
  def find_or_create_site!
    if host = URI.parse(self.url).host
      host.sub!(/^www\./,'')
      p Site
      if s = Site.where('name = ?', host).first
        self.site = s
      else
        s = self.create_site!(name:host)
      end
    else
      raise "didn't find or create a site for page: #{self.inspect}"
    end
    save!
    s
  end
  
  def find_author!
    self.author = Author.create!
    save!
    self.author
  end
end

__END__

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
    :fostered   => :orphaned
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
  
  state :orphaned do
    def discover_identity!
      if Identity.provider_from_url(self.url) and
          self.identity = Identity.find_or_create_from_url(self.url)
        adopt!
      else
        reject!
      end
    end
  end
  
  state :spiderable do
    def find_identity_from_author_link!
      author_tag = Nokogiri::HTML(open(self.url)).css('link[rel=author]')
      unless author_tag.blank?
        if author_link = author_tag.attr('href').value                   
          self.identity = Identity.find_or_create_from_url(author_link)
          adopt!
        else
          reject!
        end
      else
        reject!
      end
    end
  end
end

