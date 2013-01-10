class Authors::Twitter < Author
  include Enqueueable
  include TwitterMessages
  def self.discover_uid_and_username_from_url url
    uri = URI.parse(url)
    if %r{!/}.match(uri.fragment)
      screen_name = %r{!/}.match(uri.fragment).post_match
    else
      screen_name = uri.path.split('/')[1]
    end
    { :username => screen_name }
  end

  # def populate_uid_from_username!
  #   super do
  #     self.uid = ::Twitter.user(self.username).id.to_s
  #   end
  # end

  # def populate_username_from_uid! 
  #   super do
  #     self.username = ::Twitter.user(self.uid.to_i).screen_name
  #   end
  # end

  # private

  def send_tweet(tweet)
    raise 'tweet to long' if tweet.length + self.username.length + 2 > 140
    Twitter.update('@' + self.username + ' ' + tweet )
  end
end
