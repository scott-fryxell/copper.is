  class Authors::Twitter < Author
  include Enqueueable
  include Messageable::Twitter

  def self.discover_uid_and_username_from_url url

    uri = URI.parse(url)
    if %r{!/}.match(uri.fragment)
      screen_name = %r{!/}.match(uri.fragment).post_match
    else
      screen_name = uri.path.split('/')[1]
    end

    twitter_id = @@client.user(screen_name).id.to_s
    { username:screen_name, uid: twitter_id}
  end

  def populate_uid_from_username!

    super do
      self.uid = @@client.user(self.username).id.to_s
    end
  end

  def populate_username_from_uid!


    super do
      self.username = @@client.user(self.uid.to_i).screen_name
    end
  end

  def profile_image

    super do
      begin
        @@client.user(self.username).profile_image_url_https.to_s().gsub(/_normal/, '')
      rescue Exception
        "/assets/icons/silhouette.svg"
      end
    end
  end

  @@config = {
    consumer_key: Copper::Application.config.twitter_key,
    consumer_secret:  Copper::Application.config.twitter_secret,
    access_token: Copper::Application.config.twitter_oauth_key,
    access_token_secret: Copper::Application.config.twitter_oauth_secret
  }
  @@client = Twitter::REST::Client.new(@@config)

end
