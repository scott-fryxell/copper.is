module URL
  module Learnable
    extend ActiveSupport::Concern
    include URL::Spiderable

    included do
      after_create do |page|
        Resque.enqueue page.class, page.id, :learn
      end

    end

    def learn (content = self.spider.get(url))
      
      logger.info " "
      logger.info "<- Learn about  id:#{id}, url: #{url[0...100]} -> "

      learn_url(content)

      learn_image(content)

      learn_title(content)

      learn_description(content)

      logger.info self.author_state
      logger.info "->"

      save!

    end

    def learn_description ( content = self.spider.get(url) )
      if description_tag = content.at('meta[property="og:description"]')
        logger.info "    og:description=#{description_tag.attributes['content'].value[0...100]}"
        self.description = description_tag.attributes['content'].value
      elsif description_tag = content.at('meta[name="description"]')
        logger.info "    description=#{description_tag.attributes['content'].value[0...100]}"
        self.description = description_tag.attributes['content'].value
      end
      self.description
    end

    def learn_title ( content = self.spider.get(url) )
      logger.info "  title"
      if title_tag = content.at('meta[property="og:title"]')
        logger.info "    og:title=#{title_tag.attributes['content'].value[0...100]}"
        self.title = title_tag.attributes['content'].value
      elsif title_tag = content.at('title')
        logger.info "    title=#{title_tag.text.strip[0...100]}"
        self.title = title_tag.text.strip
      end
      self.title
    end

    def learn_url ( content = self.spider.get(url) )
      logger.info "  url"
      if url_tag = content.at('meta[property="og:url"]')
        logger.info "    og:url=#{url_tag.attributes['content'].value[0...100]}"
        self.url = url_tag.attributes['content'].value
      end
      self.url
    end

    def learn_image ( content = self.spider.get(url) )
      logger.info "  thumbnail"

      if thumbnail_tag = content.at('meta[property="og:image"]')
        logger.info "    og:image=#{thumbnail_tag.attributes['content'].value[0...100]}"
        self.thumbnail_url = thumbnail_tag.attributes['content'].value
      elsif thumbnail_tag = content.at('link[rel="image_src"]')
        logger.info "    image_src=#{thumbnail_tag.attributes['href'].value[0...100]}"
        self.thumbnail_url = thumbnail_tag.attributes['href'].value
      elsif thumbnail_tag = content.at('link[rel="thumbnailUrl"]')
        logger.info "    thumbnailUrl=#{thumbnail_tag.attributes['href'].value[0...100]}"
        self.thumbnail_url = thumbnail_tag.attributes['href'].value
      end
      self.thumbnail_url
    end

  end

end
