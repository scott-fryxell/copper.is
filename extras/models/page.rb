class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  
  belongs_to :author
  has_many :tips
  has_many :checks, :through => :tips
  has_many :channels

  attr_accessible :url, :type

  validates :url, :presence => true, :uniqueness => true
  
  before_create do |page|
    page.set_site
  end
  
  # after_create do |page|
  #   Resque.enqueue Page, page.id, :find_author!
  # end
  
  def set_site
    if host = URI.parse(self.url).host
      host.sub!(/^www\./,'')
      self.site = host
    end
  end
  
  [:orphaned, :manual, :adopted].each do |state|
    scope state, where("author_state = ?", state)
  end
  
  state_machine :author_state, initial: :orphaned do
    event :adopt do
      transition any => :adopted
    end
    
    event :reject do
      transition any => :manual
    end
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


