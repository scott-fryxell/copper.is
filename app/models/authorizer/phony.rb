class Authorizer::Phony < Author

  include Enqueueable
  include Message::Desirable::Phony

  def self.identity_from_url url
    screen_name = URI.parse(url).path.gsub('/','')
    { provider:'phony', uid: screen_name, username:screen_name }
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
