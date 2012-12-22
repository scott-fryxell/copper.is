class Identities::Flickr < Identity
  def self.discover_uid_and_username_from_url url
    user_name =  URI.parse(url).path.split('/')[2]
    { username:user_name }    
  end

  def inform_non_user_of_promised_tips
    super do
    end
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
