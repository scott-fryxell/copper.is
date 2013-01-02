class Identities::Flickr < Identity
  def self.discover_uid_and_username_from_url url
    user_name =  URI.parse(url).path.split('/')[2]
    { username:user_name }    
  end

end
