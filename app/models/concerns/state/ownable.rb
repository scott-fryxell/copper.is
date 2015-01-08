module State
  module Ownable

    extend ActiveSupport::Concern

    include URL::Spiderable

    included do

      after_create do |page|
        if page.orphaned?
          Resque.enqueue page.class, page.id, :discover_author_from_url!
        end
      end

      [:adopted, :orphaned, :fostered, :homeless, :dead].each do |state|
        scope state, -> { where(author_state:state) }
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
      state_machine :author_state, initial: :orphaned do

        event :adopt do
          transition any => :adopted
        end

        event :kill do
          transition any => :dead
        end

        event :reject do
          transition :adopted    => :orphaned,
                     :orphaned   => :fostered,
                     :fostered   => :homeless,
                     :homeless   => :dead,
                     :dead       => :orphaned
        end

        after_transition any => :orphaned do |page, transition|
          Resque.enqueue page.class, page.id, :discover_author_from_url!
        end

        after_transition any => :fostered do |page, transition|
          Resque.enqueue page.class, page.id, :discover_author_from_page!
        end

        after_transition any => :homeless do |page, transition|
           Resque.enqueue page.class, page.id, :spider_page_for_leads
        end

        after_transition any => :dead do |page, transition|
          Resque.enqueue page.class, page.id, :refund_paid_tips!
        end

        after_transition :adopted => :adopted do |page, transition|
          # respider the page for images
          Resque.enqueue page.class, page.id, :learn
        end

        state :orphaned do

          def discover_author_from_url!
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

          def discover_author_from_page!
            begin
              logger.info "page links for: id=#{id}, #{url[0...100]}"
              self.spider.get(url) do |page|

                discover_author_from_link_elements! page

                discover_author_from_wordpress_blog! page

                discover_author_from_a_elements! page

                reject! unless self.author
              end

            rescue Mechanize::ResponseCodeError => e
              if '404' == e.response_code or '410' == e.response_code
                logger.info "    dead: #{self.url}, ResponseCodeError: #{e.response_code} "
                self.kill!
              else
                self.reject!
              end
            rescue Net::HTTP::Persistent::Error => e
              logger.info "    dead: #{self.url}"
              self.kill!
            end
          end

          def discover_author_from_link_elements! page
            if author_link = page.at('link[rel=author]')
              href = author_link.attributes['href'].value

              logger.info "    author: #{href[0...100]}"
              if self.author = Author.find_or_create_from_url(href)
                log_adopted
                return adopt!
              end
            end
          end

          def discover_author_from_wordpress_blog! page

            if author_link = page.at('#follow-us a')
              href = author_link.attributes['href'].value
              # TODO: prioritize twitter tumblr facebook
              logger.info "    author: #{href[0...100]}"
              if self.author = Author.find_or_create_from_url(href)
                log_adopted
                return adopt!
              end

            end
          end

          def discover_author_from_a_elements! page
            page.links_with(:href => %r{twitter.com|tumblr.com|facebook.com|plus.google.com|soundcloud.com|git.com}).each do |link|
              if Author.identity_from_url(link.href)
                self.author = Author.find_or_create_from_url(link.href)
                log_adopted
                return adopt!
              end
            end
          end

        end

        state :homeless do
          def spider_page_for_leads
            #TODO: spider page for leads to the author
          end

        end

        state :dead do

          def refund_paid_tips!
            #TODO: refund paid tips.
          end

        end
      end

    end

    module ClassMethods
      def adoption_rate
        (Float(Page.adopted.count)/Float(Page.all.count - Page.dead.count) * 100).round
      end
    end

  private

    def log_adopted
      logger.info "    adopted:{ provider:#{self.author.provider}, username=#{self.author.username}, uid=#{self.author.uid}, id=#{self.author.id} }"
    end

  end
end
