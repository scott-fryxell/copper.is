class Identities::Twitter < Identity
  validates :username, presence: true

  def inform_non_user_of_promised_tips
    if user_id.nil? 
      send_tweet("Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
    end
  end

  def send_tweet(tweet)
    raise 'tweet to long' if tweet.length + self.username.length + 2 > 140
    Twitter.update('@' + self.username + ' ' + tweet )
  end
  
end
