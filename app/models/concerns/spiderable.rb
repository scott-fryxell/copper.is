module Spiderable

  extend ActiveSupport::Concern

  included do
    validates :url, presence:true
    validate :url_points_to_real_site
  end

  def url_points_to_real_site
    errors.add(:url, "must point to a real site") unless self.url =~ /\./
  end

  def learn (content = self.spider.get(url))
    logger.info " "
    logger.info "<- Learn about  id:#{id}, url: #{url[0...100]} -> "

    learn_url(content)

    learn_image(content)

    learn_title(content)

    learn_description(content)

    logger.info "->"
    self.save!

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

  def spider
    return Mechanize.new do |a|
      a.post_connect_hooks << lambda do |_,_,response,_|
        if response.content_type.nil? || response.content_type.empty?
          response.content_type = 'text/html'
        end
      end
    end
  end

end
