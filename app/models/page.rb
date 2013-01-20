class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  belongs_to :author
  has_many :tips
  has_many :checks, :through => :tips
  attr_accessible :title, :url

  validates :url, :presence => true
  validate :url_points_to_real_site
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

  [:adopted, :orphaned, :fostered, :dead, :manual].each do |state|
    scope state, where("author_state = ?", state)
  end

  def fan_tips(fan)
    self.tips.joins(:order).where('orders.user_id=?', fan.id)
  end

  def self.adoption_rate
    (Float(Page.adopted.count)/Float(Page.all.count - Page.dead.count) * 100).round
  end

  def thumbnail
    if thumbnail_url
      thumbnail_url
    else
      "http://img.bitpixels.com/getthumbnail?code=59482&size=200&url=#{url}"
    end
  end

  def learn
    puts "thumbnail id:#{id}, for: #{url[0...120]}"
    content = self.agent.get(url)
    
    thumbnail_tag = content.at('meta[property="og:image"]')
    unless thumbnail_tag.blank?
      puts ":    og:image=#{thumbnail_tag.attributes['content'].value[0...120]}"
      if self.thumbnail_url = thumbnail_tag.attributes['content'].value
        self.save!
        return true
      end
    end

    thumbnail_tag = content.at('link[rel="image_src"]') 
    unless thumbnail_tag.blank?
      puts ":    image_src=#{thumbnail_tag.attributes['href'].value[0...120]}"
      if self.thumbnail_url = thumbnail_tag.attributes['href'].value
        self.save!
        return true
      end
    end
    
    thumbnail_tag = content.at('link[rel="thumbnailUrl"]') 
    unless thumbnail_tag.blank?
      puts ":    thumbnailUrl=#{thumbnail_tag.attributes['href'].value[0...120]}"
      if self.thumbnail_url = thumbnail_tag.attributes['href'].value
        self.save!
        return true
      end
    end
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

    after_transition any => :manual do |page,transition|
      Resque.enqueue Page, page.id, :notify_admin_to_find_page_author!
    end

    after_transition any => :dead do |page,transition|
      Resque.enqueue Page, page.id, :clean_up_dead_page!
    end

    state :orphaned do
      def discover_author! 
        puts "discover_author for: id=#{self.id}, #{self.url[0...120]}"
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
          puts "Page links for: id=#{id}, #{url[0...120]}"
          self.agent.get(url) do |doc|
            if doc.title
              self.title = doc.title
            end

            if author_link = doc.at('link[rel=author]')
              href = author_link.attributes['href'].value
              output = ":    author: #{href[0...120]}"
              puts output
              # puts output
              if self.author = Author.find_or_create_from_url(href)
                log_adopted
                return adopt!
              end
            end

            output = lambda { |link| puts ":    adopted: #{link.href[0...120]}"}

            doc.links_with(:href => %r{facebook.com}).each do |link|
              unless %r{events|sharer.php|share.php|group.php}.match(URI.parse(link.href).path)
                if self.author = Author.find_or_create_from_url(link.href) 
                  output.call link
                  return adopt!
                end
              end
            end

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
          puts ":    ResponseCodeError: #{e.response_code}"
          if '404' == e.response_code or '410' == e.response_code
            puts ":    dead: #{self.url}"
            self.author_state = 'dead'
            save!
          end
        rescue Net::HTTP::Persistent::Error => e
          puts ":    dead: #{self.url}"
          self.author_state = 'dead'
          save!
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
    puts ":    adopted: username=#{self.author.username}, uid=#{self.author.uid}, id=#{self.author.id}"
  end

end
