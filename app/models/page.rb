class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  
  belongs_to :author
  belongs_to :site
  has_many :tips
  has_many :checks, :through => :tips

  attr_accessible :url, :type

  validates :url, :presence => true

  after_create do |page|
    page.find_or_create_site!
    Resque.enqueue Page, page.id, :find_author!
  end
  
  def find_or_create_site!
    if host = URI.parse(self.url).host
      host.sub!(/^www\./,'')
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
  
  state_machine :author_state, initial: :orphaned do
    event :adopt do
      transition any => :adopted
    end
    
    event :reject do
      transition any => :manual
    end
  end
  
  def find_author!
    self.site.find_author!(self)
    self.create_author! unless self.author_id
    save!
    reload
    scrape_for_channels!
  end
  
  def path
    URI.parse(url).path
  end
  
  def scrape_for_channels!
    raise "WTF!" unless author_id
    unless Sites::Phony.match?(self.site)
      doc = Nokogiri.parse(open(self.url))
      Channel.children.each do |channel_subclass|
        if address = channel_subclass.scrape_for_address(doc)
          self.author.channels.create!(address:address, type:channel_subclass)
          self.author.save!
        end
      end
    end
  rescue OpenURI::HTTPError => e
    puts "OpenURI::HTTPError: #{self.url} : #{e.message}"
    # TODO log this
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


