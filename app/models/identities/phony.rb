class Identities::Phony < Identity
  include Enqueueable
  
  # validates :username, presence: true

  def self.discover_uid_and_username_from_url url
    screen_name = URI.parse(url).path.gsub('/','')
    { :uid => sreen_name, :username => nil }
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

  def message!
    super do
      logger.info "#{self.inspect} has been messaged!!!!"
    end
  end
end
