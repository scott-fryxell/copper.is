class Page < ActiveRecord::Base
  include Enqueueable
  has_paper_trail
  belongs_to :identity
  has_many :tips
  has_many :checks, :through => :tips
 
  attr_accessible :title, :url

  scope :trending, order("Date(updated_at), tips_count ASC")

  validates :url, :presence => true

  validate :url_points_to_real_site
  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

  [:orphaned, :spiderable, :manual, :fostered, :adopted].each do |state|
    scope state, where("author_state = ?", state)
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
  end
end
