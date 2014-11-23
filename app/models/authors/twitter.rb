class Authors::Twitter < Author
  include Enqueueable
  include Artist::Desirable::Twitter

  def self.identity_from_url url

    uri = URI.parse(url)

    if %r{!/}.match(uri.fragment)
      screen_name = %r{!/}.match(uri.fragment).post_match
    else
      screen_name = uri.path.split('/')[1]
    end

    {provider:'twitter', username:screen_name}
  end

  def self.filter_url url
    url = Author.parse_url url
    if %r{/login|/share|/status/|/intent/|/home|/share|/statuses/|/search/|/search|/bandcampstatus|/signup}.match(url.path)
      nil
    elsif %r{2012.twitter.com|business.twitter.com}.match(url.host)
      nil
    else
      'twitter'
    end
  end

  def populate_uid_from_username!
    super do
      self.uid = ask_twitter.user(username).id.to_s
    end
  end

  def populate_username_from_uid!
    super do
      self.username = ask_twitter.user(uid.to_i).screen_name
    end
  end

  def determine_image
    super do
      unless image
        self.image = ask_twitter.user(self.username).profile_image_uri.to_s().gsub(/_normal/, '')
        save!
      end
      self.image
    end
  end

private

  @@config = {
    consumer_key: Copper::Application.config.twitter_key,
    consumer_secret:  Copper::Application.config.twitter_secret,
    access_token: Copper::Application.config.twitter_oauth_key,
    access_token_secret: Copper::Application.config.twitter_oauth_secret
  }

  def ask_twitter
    @client ||= Twitter::REST::Client.new(@@config)
    return @client
  end

end
