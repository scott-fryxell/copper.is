# see lib/messages.rb for message methods

class Identities::Twitter < Identity
  include Enqueueable
  include TwitterMessages
  
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url url
    if url =~ /\/status\//
      screen_name = URI.parse(url).fragment.split('!/').last.split('/').first
    else
      screen_name = URI.parse(url).fragment.split('!/').last
    end
    { :uid => ::Twitter.user(screen_name).id.to_s, :username => screen_name }
  end

  def populate_uid_from_username!
    super do
      self.uid = ::Twitter.user(self.username).id.to_s
    end
  end

  def populate_username_from_uid! 
    super do
      self.username = ::Twitter.user(self.uid.to_i).screen_name
    end
  end

  private

  def send_tweet(tweet)
    raise 'tweet to long' if tweet.length + self.username.length + 2 > 140
    Twitter.update('@' + self.username + ' ' + tweet )
  end
end
