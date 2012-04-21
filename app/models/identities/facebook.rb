class Identities::Facebook < Identity
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url(url)
    if url =~ /set=/
      { :uid => url.split("set=").last.split("&").first.split('.').last }
    elsif url =~ /\/events\//
      doc = Nokogiri::HTML(open(url))
      { :uid => doc.to_s.split('Report').first.split('rid=').last.split('&amp').first }
    else
      facebook_user = JSON.parse(Kernel.open(url.sub(/https?:\/\/www/, 'http://graph')).read)
      { :uid => facebook_user["id"], :username => facebook_user[:username]}
    end
  end
  
  def discover_uid_and_username_from_url
    Facebook.discover_uid_and_username_from_url self.url
  end

  def inform_non_user_of_promised_tips
    super do
      send_email("Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
    end
  end

  def send_email(message)
    # raise 'tweet to long' if tweet.length + self.username.length + 2 > 140
    # Twitter.update('@' + self.username + ' ' + tweet )
  end

  def populate_uid_from_username!
    super do
    end
  end
  
  def populate_username_from_uid!
    super do
    end
  end
end
