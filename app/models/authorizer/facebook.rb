class Authorizer::Facebook < Author

  include Enqueueable
  include Message::Desirable::Facebook

  def self.identity_from_url url
    url = Author.parse_url url

    identity = { provider:'facebook'}

    if query_param = /fbid=/.match(url.query)
      identity[:uid] = query_param.post_match.split('&')[0]
    elsif %r{/profile.php}.match(url.path)
      identity[:uid] = url.query.split('id=')[1]
    else
      identity[:username] = url.path.split('/').last
    end

    unless identity[:uid] or identity[:username]
      return nil
    end
    identity
  end

  def self.filter_url url
    url = Author.parse_url url
    if %r{/sharer|/home|/login|/status/|/search|/dialog/|/signup|r.php|/recover/|/mobile/|find-friends|badges|directory|appcenter|application|events|sharer.php|share.php|group.php}.match(url.path)
      nil
    else
      'facebook'
    end
  end

  def url
    unless self.username
      populate_uid_and_username!
    end
    "https://www.facebook.com/#{self.username}"
  end

  def determine_image
    super do
      unless image
        unless self.username
          populate_uid_and_username!
        end
        image = "https://graph.facebook.com/#{self.username}/picture?type=square"
        save
      end
      image
    end
  end

  def populate_username_from_uid!

    identity = ask_facebook.get_object(uid)
    self.username = identity['username']
    identity['username']

  end

  def populate_uid_from_username!

    identity = ask_facebook.get_object(username)
    self.uid = identity['id']
    identity['id']

  end



  def ask_facebook

    @oauth ||= Koala::Facebook::OAuth.new( Copper::Application.config.facebook_appid,
                                           Copper::Application.config.facebook_secret,
                                           "/auth/facebook/callback"
                                          )
    @graph ||= Koala::Facebook::API.new(@oauth.get_app_access_token)
    return @graph
  end

end
