class Identities::Github < Identity
  def self.discover_uid_and_username_from_url url   
    username = URI.parse(url).path.split('/')[1]
    {:username => username }  
  end
  
  def discover_uid_and_username_from_url
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
