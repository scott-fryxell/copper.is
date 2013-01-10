class Authors::Soundcloud < Author

  def self.discover_uid_and_username_from_url url
    username = URI.parse(url).path.split('/')[1]
    {:username => username }  
  end

end
