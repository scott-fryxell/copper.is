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
  
  after_initialize do
    @agent = Mechanize.new do |a|
      a.post_connect_hooks << lambda do |_,_,response,_|
        if response.content_type.nil? || response.content_type.empty?
          response.content_type = 'text/html'
        end
      end
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
    # a page is dead when we try to spider it and get a 404
    event :reject do
      transition :orphaned   => :triaged,
                 :triaged    => :fostered,
                 :fostered   => :manual,
                 :manual     => :dead
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
      Resque.enqueue Page, page.id, :notify_admin_to_find_page_author!
    end

    after_transition any => :dead do |page,transition|
      Resque.enqueue Page, page.id, :clean_up_dead_page!
    end

    state :orphaned do
      def discover_identity
        begin
          discover_identity!
        rescue => e
          logger.warn "Page#discover_identity: on: #{self.url}"
          logger.error "#{e.class}: #{e.message}"
          self.reject!
          return nil
        end
      end

      def discover_identity! 
        logger.info("discover_identity for: id=#{self.id}, #{self.url}")
        if Identity.provider_from_url(self.url) and
            self.identity = Identity.find_or_create_from_url(self.url)
            log_adopted
          adopt!
        else
          reject!
        end
      end
    end

    state :triaged do
      def find_identity_from_author_link
        begin
          find_identity_from_author_link!
        rescue => e
          logger.warn "Page#find_identity_from_author_link: on: #{self.url}"
          logger.error ":    #{e.class}: #{e.message}"
          self.reject!
          return nil
        end
      end

      def find_identity_from_author_link!
        logger.info("author_link for: id=#{self.id}, #{self.url}")
        @agent.get(self.url) do |doc|
          if author_link = doc.at('link[rel=author]')
            href = author_link.attributes['href'].value
            logger.info ":    author: #{href}"
            puts ":    author: #{href}"
            if Identity.provider_from_url(href) and 
              self.identity = Identity.find_or_create_from_url(href)
              log_adopted
              adopt!
            else
              reject!
              return nil
            end
          else
            reject!
            return nil
          end
        end
      end
    end

    state :fostered do
      def find_identity_from_page_links
        begin
          find_identity_from_page_links!
        rescue => e    
          logger.warn "Page#find_identity_from_page_links: on: #{self.url}"
          logger.error ":    #{e.class}: #{e.message}"
          self.reject!
          return nil
        end
      end
      def find_identity_from_page_links!
        logger.info "page_links for: id=#{self.id}, #{self.url}"
        @agent.get(self.url) do |doc|
          self.url = doc.uri.to_s
          if doc.title
            self.title = doc.title
          end

          # if author_link = doc.at('link[rel=author]')
          #   href = author_link.attributes['href'].value
          #   logger.info ":    author: #{href}"
          #   puts ":    author: #{href}"
          #   if Identity.provider_from_url(href) and 
          #     self.identity = Identity.find_or_create_from_url(href)
          #     log_adopted
          #     return adopt!
          #   else
          # end

          doc.links_with(:href => %r{twitter.com|facebook.com|tumblr.com|plus.google.com}).each do |link|
            output = ":    link: #{link.href}"
            logger.info output
            puts output
            if Identity.provider_from_url(link.href)
              unless %r{/status/|/events/|/post/sharer|/dialog/}.match(URI.parse(link.href).path)
                if self.identity = Identity.find_or_create_from_url(link.href) 
                  log_adopted
                  return adopt!                
                end
              end
            end
          end
          reject! unless self.identity
        end
      end
    end

    state :manual do
      def notify_admin_to_find_page_author!
        # update a list for admin's to look at of pages that need authors
      end
    end

     state :dead do
      def clean_up_dead_page!
        # refund unpaid tips. 
        # remove page from the app
      end
    end
  end

  private

  def log_adopted
    output = ":    adopted: username=#{self.identity.username}, uid=#{self.identity.uid}, id=#{self.identity.id}"
    logger.info output
    puts output
  end

end
