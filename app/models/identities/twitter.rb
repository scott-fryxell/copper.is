class Identities::Twitter < Identity
  
  def send_tweet(tweet)
    raise 'tweet to long' if tweet.length + self.name.length + 2 > 140
    Twitter.update('@' + self.name + ' ' + tweet )
  end
  
end
