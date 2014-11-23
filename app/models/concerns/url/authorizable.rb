module URL
  module Authorizable
    extend ActiveSupport::Concern

    included do
      before_save do |authorized|
        authorized.type = self.class.subclass_as(authorized.provider).to_s unless authorized.type
      end

      self.authorizers.each do |provider|
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

      def subclass_as authorizer_name
        authorizer_name = 'google' if authorizer_name == 'google_oauth2'
        ("Authors::" + authorizer_name.to_s.capitalize).constantize
      end

      def authorizer_name url
        begin
          uri = URI.parse(url)
        rescue
          return nil
        end

        return nil unless /tumblr\.com$/.match(uri.host) or uri.path.size > 1 or uri.query or uri.fragment

        case uri.host
        when /facebook\.com$/ then
          Authors::Facebook.filter_url uri
        when /tumblr\.com$/ then
          Authors::Tumblr.filter_url uri
        when /twitter\.com$/ then
          Authors::Twitter.filter_url uri
        when /plus\.google\.com$/ then
          'google'
        when /vimeo\.com$/ then
          Authors::Vimeo.filter_url uri
        when /flickr\.com$/ then
          'flickr'
        when /github\.com$/ then
          Authors::Github.filter_url uri
        when /youtube\.com$/ then
          'youtube'
        when /soundcloud\.com$/ then
          Authors::Soundcloud.filter_url uri
        when /example\.com$/ then
          'phony'
        else
          nil
        end
      end

      def find_or_create_by_authorization auth
        author = Author.find_or_create_by(provider:auth['provider'], uid:auth['uid'].to_s)
        author.token = auth['credentials']['token']
        author.secret = auth['credentials']['secret']
        author.username = auth['info']['nickname']
        author.image = auth['info']['image']
        author.save
        author
      end

      def find_or_create_from_url url

        if identity = Author.identity_from_url(url)

          i_uid      = identity[:uid].to_s
          i_username = identity[:username]
          i_provider = identity[:provider]

          author = Author.where('provider = ? and (uid = ? OR username = ?)', i_provider, i_uid, i_username).first

          unless author
            author = subclass_as(i_provider).create( username:i_username, uid:i_uid, provider:i_provider )
          end

          author
        else
          nil
        end
      end

      def identity_from_url url

        unless provider = Author.authorizer_name(url)
          return nil
        end

        Author.subclass_as(provider).identity_from_url url
      end

    end

    def populate_uid_and_username!
      if uid.blank? and username.blank?
        raise "both uid and username can't be blank"
      else
        if uid.blank?
          populate_uid_from_username!
        else
          populate_username_from_uid!
        end

        save!
      end

    end

    def populate_username_from_uid!
      raise "not implemented in subclass" unless block_given?
      raise "uid is blank" if uid.blank?
      yield
    end

    def populate_uid_from_username!
      raise "not implemented in subclass" unless block_given?
      raise "username is blank" if username.blank?
      yield
    end

  end
end
