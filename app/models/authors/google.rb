class Authors::Google < Author
  include Enqueueable

  def url
    "https:///plus.google.com/#{self.uid}"
  end
  
  def self.discover_uid_and_username_from_url url
    # http://plus.google.com/110547857076579322423/
    { uid: URI.parse(url).path().split('/').last}
  end
end
