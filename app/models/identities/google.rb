class Identities::Google < Identity
  include Enqueueable
  
  def self.discover_uid_and_username_from_url url
    # http://plus.google.com/110547857076579322423/
    { uid: URI.parse(url).path().split('/').last}
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
