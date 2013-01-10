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
    else
      username_from_url = url.path.split('/').last
      begin
        fb_object = graph.get_object(username_from_url)
        username = fb_object['username']
        id = fb_object['id']
      rescue
        username = username_from_url 
      end
    end
    { :uid => id, :username => username}
  end

end
