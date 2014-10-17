module URL
  module Ownable

    extend ActiveSupport::Concern

    include URL::Spiderable

    included do

      after_create do |page|
        if page.orphaned?
          Resque.enqueue page.class, page.id, :discover_author!
        end
      end

      [:adopted, :orphaned, :fostered, :dead, :manual].each do |state|
        scope state, -> { where(author_state:state) }
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

        after_transition any => :orphaned do |page, transition|
          Resque.enqueue page.class, page.id, :discover_author!
        end

        after_transition any => :fostered do |page, transition|
          Resque.enqueue page.class, page.id, :discover_author_from_page_links!
        end


        # after_transition any => :manual do |page, transition|
        # TODO:   Resque.enqueue Page, page.id, :notify_admin_to_find_page_author!
        # end

        after_transition any => :dead do |page, transition|
          Resque.enqueue page.class, page.id, :refund_paid_tips!
        end

        after_transition :adopt => :adopt do |page, transition|
          # respider the page for images
          Resque.enqueue page.class, page.id, :learn
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

          def discover_author_from_page_links!
            begin
              logger.info "page_links for: id=#{id}, #{url[0...100]}"
              self.spider.get(url) do |doc|
                if doc.title
                  self.title = doc.title
                end

                if author_link = doc.at('link[rel=author]')
                  href = author_link.attributes['href'].value
                  output = "    author: #{href[0...100]}"
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
              logger.info "    ResponseCodeError: #{e.response_code}"
              if '404' == e.response_code or '410' == e.response_code
                logger.info "    dead: #{self.url}"
                self.author_state = 'dead'
                save!
              end
            rescue Net::HTTP::Persistent::Error => e
              logger.info "    dead: #{self.url}"
              self.author_state = 'dead'
              save!
            end
          end

        end

        state :manual do
          # do some stuff here
        end

        state :dead do

          def refund_paid_tips!
            #TODO: refund unpaid tips.
          end

        end
      end

    end

  private

    def log_adopted
      logger.info "    adopted: username=#{self.author.username}, uid=#{self.author.uid}, id=#{self.author.id}"
    end

  end
end
