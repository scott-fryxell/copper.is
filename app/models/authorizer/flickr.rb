class Authorizer::Flickr < Author

  include Enqueueable
  include Message::Desirable::Flickr

  def self.identity_from_url url
    user_name =  URI.parse(url).path.split('/')[2]
    { username:user_name, provider:'flickr' }
  end

end
