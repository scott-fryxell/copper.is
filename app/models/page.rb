class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  belongs_to :identity, :touch => true
  has_many :tips
  has_many :checks, :through => :tips
 
  attr_accessible :title, :url, :thumbnail_url

  validates :url, :presence => true
  validate :url_points_to_real_site
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

  [:adopted, :orphaned, :triaged, :fostered, :manual].each do |state|
    scope state, where("author_state = ?", state)
  end

  def fan_tips(fan)
   self.tips.joins(:order).where('orders.user_id=?', fan.id)
  end

  def discover_thumbnail
    begin
      thumbnail_tag = Nokogiri::HTML(open(self.url)).css('link[itemprop="thumbnailUrl"]')
      unless thumbnail_tag.blank?
        self.thumbnail_url = thumbnail_tag.attr('href').value
        save!
      end
    rescue
      p "error trying to load url #{url}" 
    end
  end

  def self.discover_thumbnails
    Page.all.each do |page|
      page.discover_thumbnail
    end
  end

  after_create do |page|
    if page.orphaned?
      Resque.enqueue Page, page.id, :discover_identity!
    end
  end


  state_machine :author_state, initial: :orphaned do

    event :adopt do
      transition any => :adopted
    end
    
    # Pages are initially orphaned. An attempt is made to 
    # deternime the author based on the url, failure means 
    # the page is transfered to social_services where there is an 
    # atempt to find the author via the author link if none
    # is found then the page is put in foster care where all the 
    # links on the page are spidered and a list of possible
    # identities are determined. If none are found then the 
    # page is put into manual mode where a person is going to
    # get involved to figure it out. If at any point in this 
    # chain a page is adopted it has reached it's final state. 
    event :reject do
      transition :orphaned   => :triaged,
                 :triaged    => :fostered,
                 :fostered   => :manual,
                 :manual     => :orphaned
    end

    after_transition any => :orphaned do |page,transition|
      Resque.enqueue Page, page.id, :discover_identity!
    end

    after_transition any => :triaged do |page,transition|
      Resque.enqueue Page, page.id, :find_identity_from_author_link!
    end

    after_transition any => :fostered do |page,transition|
      Resque.enqueue Page, page.id, :find_identity_from_page_links!
    end

    after_transition any => :manual do |page,transition|
      Resque.enqueue Page, page.id, :message_admin_to_find_page_author!
    end

    state :orphaned do
      def discover_identity!
        if URI.parse(self.url).path.size <= 1
          reject!
        elsif Identity.provider_from_url(self.url) and
            self.identity = Identity.find_or_create_from_url(self.url)
          adopt!
        else
          reject!
        end
      end
    end

    state :triaged do
      def find_identity_from_author_link!
        author_tag = Nokogiri::HTML(open(self.url)).css('link[rel=author]')
        unless author_tag.blank?
          if author_link = author_tag.attr('href').value
            self.identity = Identity.find_or_create_from_url(author_link)
            adopt!
            if self.identity.stranger?
              self.identity.publicize!
            end
          else
            reject!
          end
        else
          reject!
        end
      end
    end

    state :fostered do
      def find_identity_from_page_links!
        doc = Nokogiri.parse(open(self.url))
        self.title = doc.title
        doc.css('a').each do |link|
          href = link.attr(:href)
          Identity.lookups.each do |query|
            type, matcher, extract = query[:type], query[:matcher]
            if href && matcher.call(href)
              self.identity = Identity.find_or_create_from_url(href)
            end
          end
        end
        if self.identity
          adopt!
        else
          reject!
        end
        save!
      rescue OpenURI::HTTPError, SocketError
        logger.warn("Page#scrape_for_channels got 404, page still orphaned: #{self.url}")
      rescue RuntimeError => e
        logger.error("Page#scrape_for_channels: #{e.class}: #{e.message}")
      rescue URI::InvalidURIError => e
        logger.warn("Page#scrape_for_channels: #{e.class}: #{e.message}")
      end
    end

    state :manual do
      def message_admin_to_find_page_author!
        # update a list for admin's to look at of pages that need authors
      end
    end
  end
end
