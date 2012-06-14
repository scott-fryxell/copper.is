class Page < ActiveRecord::Base
  has_paper_trail
  
  include Enqueueable
  
  has_many :channels
  belongs_to :author
  
  validates :url, presence:true, uniqueness:true
  
  [:orphaned, :manual, :adopted].each do |state|
    scope state, where("author_state = ?", state)
  end
  
  state_machine :page_state, initial: :orphaned do
    event :adopt do
      transition any => :adopted
    end
    
    event :reject do
      transition any => :manual
    end
  end
  
  def self.spider(url,author_id = nil)
    page = Page.create!(url:url) || Page.where('url = ?',url).count > 0
    if author_id
      page.author_id = author_id if author_id
    else
      page.create_author! unless page.author
    end
    page.save!
    Resque.enqueue Page, page.id, :scrape_for_channels 
  end
  
  def self.channels
    @channels
  end
  
  @channels = [
    {
      site:'github.com',
      matcher:proc{|a| a =~ %r{github\.com\/[^/]+}},
      extract:proc{|a| %r{github\.com\/([^/]+)}.match(a)[1] rescue nil},
      auth:true
    },{
      site:'soundcloud.com',
      matcher:proc{|a| a =~ /soundcloud\.com/},
      extract:proc{|a| /soundcloud\.com\/([^\/]+)/.match(a)[1] rescue nil},
      auth:true
    },{
      site:'twitter.com',
      matcher:proc{|a| a =~ /twitter\.com/},
      extract:proc{|a| /twitter\.com\/([^\/]+)/.match(a)[1] rescue nil},
      auth:true
    },{
      site:'rubygems.org',
      matcher:proc{|a| a =~ /rubygems\.org/},
      extract:proc{|a| /rubygems\.org\/(profiles\/[0-9]+)/.match(a)[1] rescue nil}
    }
  ]
  
  def scrape_for_channels
    doc = Nokogiri.parse(open(self.url))
    self.title = doc.title
    doc.css('a').each do |link|
      href = link.attr(:href)
      Page.channels.each do |ch|
        site, matcher, extract, auth = ch[:site], ch[:matcher], ch[:extract], ch[:auth]
        if href && matcher.call(href) && user = extract.call(href)
          Page.create!(url:href,author:author) unless Page.where('url = ?',href).count > 0
          channels.create! site:site, user:user unless
            channels.where('site = ? and user = ?', site, user).count > 0
          if auth
            author.auth_sources.create! site:site, user:user unless
              author.auth_sources.where('site = ? and user = ?', site, user).count > 0
          end
        end
      end
    end
    if channels.count > 0
      adopt!
    else
      reject!
    end
    save!
  rescue OpenURI::HTTPError, SocketError
    logger.warn("Page#scrape_for_channels got 404, page still orphaned: #{self.url}")
  end
  
  def self.add_http_if_missing(url)
    url =~ /^http/ ? url : 'http://' + url
  end
  
  def self.site_from_url(url)
    URI.parse(url).host.sub(/^www\./,'')
  end
  
  def self.path_from_url(url)
    to_return = URI.parse(url).path.sub(/^\//,'')
  end
  
  before_save do |page|
    page.url  = Page.add_http_if_missing(url)
    page.site = Page.site_from_url(page.url)
    page.path = Page.path_from_url(page.url)
    true
  end
end
