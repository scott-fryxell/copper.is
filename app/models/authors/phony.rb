class Authors::Phony < Author
  include Enqueueable
  include PhonyMessages
  
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url url
    screen_name = URI.parse(url).path.gsub('/','')
    { :uid => screen_name, :username => screen_name }
  end

  def populate_uid_from_username!
    super do
      self.uid = self.username
    end
  end

  def populate_username_from_uid! 
    super do
      self.username = self.uid
    end
  end
end
