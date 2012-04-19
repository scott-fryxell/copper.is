class Identities::Facebook < Identity
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url url
    if url =~ /set=/
      [url.split("set=").last.split("&").first.split('.').last, nil]
    elsif url =~ /\/events\//
      doc = Nokogiri::HTML(open(url))
      [doc.to_s.split('Report').first.split('rid=').last.split('&amp').first,nil]
    else
      logger.info "reaching out to: #{url}"
      doc = Nokogiri::HTML(open(url))
      [ JSON.parse(doc.css('#pagelet_timeline_main_column').attr('data-gt').content)['profile_owner'],nil]
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

  def send_email(tweet)
    raise 'tweet to long' if tweet.length + self.username.length + 2 > 140
    Twitter.update('@' + self.username + ' ' + tweet )
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
