class Page < ActiveRecord::Base
  has_paper_trail
  include Enqueueable
  has_many :channels
  
  validates :url, presence:true, uniqueness:true
  
  def self.spider(url)
    page = Page.create!(url:url)
    Resque.enqueue Page, page.id, :scrape_for_channels 
  end
  
  def scrape_for_channels
    doc = Nokogiri.parse(open(self.url))
    doc.css('a').each do |link|
      Page.channels.each do |type,matcher,extractor|
        if link.attr(:href) and matcher.call(link.attr(:href))
          channels.create!(type:type,user:extractor.call(link.attr(:href)))
        end
      end
    end
  end
  
  def self.add_http_if_missing(url)
    url =~ /^http/ ? url : 'http://' + url
  end
  
  def self.site_from_url(url)
    URI.parse(url).host.sub(/^www\./,'')
  end
  
  def self.path_from_url(url)
    URI.parse(url).path.sub(/^\//,'')
  end
  
  before_save do |page|
    page.url  = Page.add_http_if_missing(url)
    page.site = Page.site_from_url(page.url)
    page.path = Page.path_from_url(page.url)
    p page
    true
  end
end
