class Authors::Facebook < Author
  include Enqueueable
  include FacebookMessages
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url url
    graph = Koala::Facebook::API.new()
    url = URI.parse(url)
    if match = /fbid=/.match(url.query)
      id_from_url = match.post_match.split('&')[0]
      begin
        fb_photo = graph.get_object(id_from_url)
        username = fb_photo['from']['name']
        id = fb_photo['from']['id']
      rescue
        id = id_from_url
      end
    elsif match = %r{/profile.php}.match(url.path)
      id_from_url = url.query.split('id=')[1]
      begin
        fb_object = graph.get_object(id_from_url)
        username = fb_object["username"]
        id = fb_object['id']
      rescue
        id = id_from_url
      end
      elsif match = %r{/application.php}.match(url.path)
       return nil
    else
      username_from_url = url.path.split('/').last
      begin
        fb_object = graph.get_object(username_from_url)
        username = fb_object['username']
        id = fb_object['id']
      rescue
        id= nil
        username=nil
      end
    end
    if id == nil and username == nil
      return nil
    end
    {:uid => id, :username => username}
  end

  def url
    unless self.username
      populate_username_from_uid!
      save!
    end
    "https://www.facebook.com/#{self.username}"
  end

  def profile_image
    super do
      unless self.username
        populate_username_from_uid!
        save!
      end
      "https://graph.facebook.com/#{self.username}/picture?type=square"
    end
  end

  def populate_username_from_uid!
    fb_object = graph.get_object(self.uid)
    self.username = fb_object['username']
  end

  def populate_uid_from_username!
    fb_object = graph.get_object(self.username)
    self.uid = fb_object['id']
  end

private
  def graph
    @oauth ||= Koala::Facebook::OAuth.new(Copper::Application.config.facebook_appid, Copper::Application.config.facebook_secret, "/auth/facebook/callback")
    @graph ||= Koala::Facebook::API.new(@oauth.get_app_access_token)
  end
end
