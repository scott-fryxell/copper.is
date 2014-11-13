module URL
  module Authorizable
    extend ActiveSupport::Concern

    included do
      before_save do |authorized|
        authorized.type = self.class.subclass_by_authorizer(authorized.provider).to_s unless authorized.type
      end

      Author.authorizers.each do |provider|
        scope provider, -> { where(provider:provider) }
      end

    end

    module ClassMethods

      @@authorizers = [ :twitter, :facebook,   :tumblr,
                        :phony,   :soundcloud, :github,
                        :vimeo,   :flickr,     :google ]

      def authorizers
        @@authorizers
      end

      # TODO: merge this into find_or_create_with_omniauth
      def find_or_create_by_authorization(auth)
        author = self.find_or_create_by(provider:auth['provider'], uid:auth['uid'].to_s)
        author.token = auth['credentials']['token']
        author.secret = auth['credentials']['secret']
        author.username = auth['info']['nickname']
        author.save
        author
      end

      def subclass_by_authorizer(authorizer)
        authorizer = 'google' if authorizer == 'google_oauth2'
        ("Authors::" + authorizer.to_s.capitalize).constantize
      end

      def authorizer_from_url(url)
        begin
          uri = URI.parse(url)
          return nil unless /tumblr\.com$/.match(uri.host) or uri.path.size > 1 or uri.query or uri.fragment
        rescue => e
          return nil
        end

        case uri.host
        when /facebook\.com$/ then
          if %r{/sharer|/home|/login|/status/|/search|/dialog/|/signup|r.php|/recover/|/mobile/|find-friends|badges|directory|appcenter|application|events|sharer.php|share.php|group.php}.match(uri.path)
            nil
          else
            'facebook'
          end
        when /tumblr\.com$/ then
          if %r{www.tumblr.com}.match(uri.host) and uri.path.size < 3
            nil
          elsif %r{/dashboard|/customize|/post|/liked/|/share}.match(uri.path)
            nil
          else
            'tumblr'
          end
        when /twitter\.com$/ then
          if %r{/login|/share|/status/|/intent/|/home|/share|/statuses/|/search/|/search|/bandcampstatus|/signup}.match(uri.path)
            nil
          elsif %r{2012.twitter.com|business.twitter.com}.match(uri.host)
            nil
          else
            'twitter'
          end
        when /plus\.google\.com$/ then 'google'
        when /vimeo\.com$/ then
          if %r{/groups/|/share/}.match(uri.path)
            nil
          else
            'vimeo'
          end
        when /flickr\.com$/ then 'flickr'
        when /github\.com$/ then
          if %r{gist.github.com}.match(uri.host)
            nil
          elsif %r{/blog}.match(uri.path)
            nil
          else
            'github'
          end
        when /youtube\.com$/ then 'youtube'
        when /soundcloud\.com$/ then
          if  %r{/dashboard}.match(uri.path)
            nil
          else
            'soundcloud'
          end
        when /example\.com$/ then 'phony'
        else
          nil
        end
      rescue URI::InvalidURIError => e
        return nil
      end

    end

  end
end
