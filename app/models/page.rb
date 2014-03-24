class Page < ActiveRecord::Base
  include Enqueueable

  has_paper_trail
  belongs_to :author
  has_many :tips
  has_many :checks, :through => :tips
  attr_accessible :title, :url, :author_state
  attr_accessor :nested
  validates :url, :presence => true
  validate :url_points_to_real_site
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

  [:adopted, :orphaned, :fostered, :dead, :manual].each do |state|
    scope state, where("author_state = ?", state)
  end

  scope :welcome, where(welcome:true)
  scope :onboarding, where(onboarding:true)
  scope :trending, where(trending:true)

  scope :safe, where(nsfw:false)
  scope :recent, order("pages.created_at DESC")
  scope :charged_tips, joins(:tips).where('tips.paid_state=?', 'charged')
  scope :order_by_tips, joins(:tips).select('pages.*, count("tips") as tips_pending_count').group('pages.id').order('tips_pending_count desc')

  def initialize(attributes={})
    super
    @nested ||= false
  end

  def self.scott
    User.find_by_email('scott@copper.is').pages
  end

  def self.adoption_rate
    (Float(Page.adopted.count)/Float(Page.all.count - Page.dead.count) * 100).round
  end

  def as_item_attributes
    unless @nested
      "itemscope itemtype='page' itemid='#{self.item_id}' itemprop='author_state' data-author_state='#{self.author_state}'"
    end
  end

  def item_id
    "/pages/#{self.id}"
  end

  def nested?
    return nested
  end



  def thumbnail
    if thumbnail_url
      thumbnail_url
    else
      "/assets/noun_project/37233.svg"
    end
  end

  def tips_by_fan_in_cents (user)
    user.tips.where(page_id:self.id).sum(:amount_in_cents)
  end

  def learn_title(content = self.agent.get(url))
    logger.info ":  title"

    if title_tag = content.at('meta[property="og:title"]')
      logger.info ":    og:title=#{title_tag.attributes['content'].value[0...100]}"
      title = title_tag.attributes['content'].value
    end
    title
  end

  def learn_url (content = self.agent.get(url))
    logger.info ":  url"
    if url_tag = content.at('meta[property="og:url"]')
      logger.info ":    og:url=#{url_tag.attributes['content'].value[0...100]}"
      self.url = url_tag.attributes['content'].value
    end
    self.url
  end

  def learn_image(content = self.agent.get(url))
    logger.info ":  thumbnail"

    if thumbnail_tag = content.at('meta[property="og:image"]')
      logger.info ":    og:image=#{thumbnail_tag.attributes['content'].value[0...100]}"
      self.thumbnail_url = thumbnail_tag.attributes['content'].value
    elsif thumbnail_tag = content.at('link[rel="image_src"]')
      logger.info ":    image_src=#{thumbnail_tag.attributes['href'].value[0...100]}"
      self.thumbnail_url = thumbnail_tag.attributes['href'].value
    elsif thumbnail_tag = content.at('link[rel="thumbnailUrl"]')
      logger.info ":    thumbnailUrl=#{thumbnail_tag.attributes['href'].value[0...100]}"
      self.thumbnail_url = thumbnail_tag.attributes['href'].value
    end
    thumbnail_url
  end

  def learn (content = self.agent.get(url))
    logger.info " "
    logger.info "<- Learn about  id:#{id}, url: #{url[0...100]} -> "
    learn_url(content)
    learn_title(content)
    learn_image(content)
    self.save!
    self
  end

  def agent
    return Mechanize.new do |a|
      a.post_connect_hooks << lambda do |_,_,response,_|
        if response.content_type.nil? || response.content_type.empty?
          response.content_type = 'text/html'
        end
      end
    end
   end

  after_create do |page|
    if page.orphaned?
      Resque.enqueue Page, page.id, :discover_author!
    end
    Resque.enqueue Page, page.id, :learn
  end

  state_machine :author_state, initial: :orphaned do

    event :adopt do
      transition any => :adopted
    end

    # Pages are initially orphaned. An attempt is made to
    # deternime the author based on the url, failure means
    # page is put in foster care where all the links on
    # the page are spidered and a list of possible
    # authors are determined. If none are found then the
    # page is put into manual mode where a person is going to
    # get involved to figure it out. If at any point in this
    # chain a page is adopted it has reached it's final state.
    # a page is dead when we try to spider it and get a 404
    event :reject do
      transition :orphaned   => :fostered,
                 :fostered   => :manual,
                 :manual     => :dead
    end

    after_transition any => :orphaned do |page,transition|
      Resque.enqueue Page, page.id, :discover_author!
    end

    after_transition any => :fostered do |page,transition|
      Resque.enqueue Page, page.id, :find_author_from_page_links!
    end

    # after_transition any => :manual do |page,transition|
    #   Resque.enqueue Page, page.id, :notify_admin_to_find_page_author!
    # end

    after_transition any => :dead do |page,transition|
      Resque.enqueue Page, page.id, :refund_paid_tips!
    end

    after_transition :adopt => :adopt do |page,transition|
      # respider the page for images
      Resque.enqueue Page, page.id, :learn
    end


    state :orphaned do

      def discover_author!
        logger.info "discover_author for: id=#{self.id}, #{self.url[0...100]}"
        if self.author = Author.find_or_create_from_url(self.url)
          log_adopted
          adopt!
        else
          reject!
        end
      end

    end

    state :fostered do

      def find_author_from_page_links!
        begin
          logger.info "page_links for: id=#{id}, #{url[0...100]}"
          self.agent.get(url) do |doc|
            if doc.title
              self.title = doc.title
            end

            if author_link = doc.at('link[rel=author]')
              href = author_link.attributes['href'].value
              output = ":    author: #{href[0...100]}"
              logger.info output
              if self.author = Author.find_or_create_from_url(href)
                log_adopted
                return adopt!
              end
            end
            output = lambda { |link| logger.info ":    adopted: #{link.href[0...100]}"}
            doc.links_with(:href => %r{twitter.com}).each do |link|
              # filter for known twitter links that are providerable but not good for spidering links
              unless %r{/status/|/intent/|/home|/share|/statuses/|/search/|/search|/bandcampstatus|/signup}.match(URI.parse(link.href).path)
                if self.author = Author.find_or_create_from_url(link.href)
                  output.call link
                  return adopt!
                end
              end
            end

            doc.links_with(:href => %r{tumblr.com}).each do |link|
              unless %r{/post/|/liked/|/share}.match(URI.parse(link.href).path)
                if self.author = Author.find_or_create_from_url(link.href)
                  output.call link
                  return adopt!
                end
              end
            end

            doc.links_with(:href => %r{facebook.com}).each do |link|
              unless %r{events|sharer.php|share.php|group.php}.match(URI.parse(link.href).path)
                if self.author = Author.find_or_create_from_url(link.href)
                  output.call link
                  return adopt!
                end
              end
            end

            doc.links_with(:href => %r{plus.google.com}).each do |link|
              unless %r{/share/}.match(URI.parse(link.href).path)
                if self.author = Author.find_or_create_from_url(link.href)
                  output.call link
                  return adopt!
                end
              end
            end

            reject! unless self.author
          end
        rescue Mechanize::ResponseCodeError => e
          logger.info ":    ResponseCodeError: #{e.response_code}"
          if '404' == e.response_code or '410' == e.response_code
            logger.info ":    dead: #{self.url}"
            self.author_state = 'dead'
            save!
          end
        rescue Net::HTTP::Persistent::Error => e
          logger.info ":    dead: #{self.url}"
          self.author_state = 'dead'
          save!
        end
      end

    end

    state :manual do
    end

    state :dead do

      def refund_paid_tips!
        #TODO: refund unpaid tips.
      end

    end
  end

  private

  def log_adopted
    logger.info ":    adopted: username=#{self.author.username}, uid=#{self.author.uid}, id=#{self.author.id}"
  end
end
