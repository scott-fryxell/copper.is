module URL
  module Spiderable

    extend ActiveSupport::Concern

    included do
      validates :url, presence:true
      validate :url_points_to_real_site
    end

    def url_points_to_real_site
      errors.add(:url, "must point to a real site") unless self.url =~ /\./
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
end
